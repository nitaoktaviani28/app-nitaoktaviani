# ---------- Build stage ----------
FROM golang:1.22-alpine AS builder

WORKDIR /build

RUN apk update && apk add --no-cache git

RUN git clone https://gitlab.adinusa.id/bta-adinusa/notes-wiki.git .

RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o web main.go

# ---------- Runtime stage ----------
FROM alpine:3.19

LABEL maintainer="username_adinusa"

WORKDIR /app

COPY --from=builder /build/web /app/web
COPY --from=builder /build/template /app/template

EXPOSE 8686

CMD ["/app/web"]

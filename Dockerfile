# ---------- Build stage ----------
FROM golang:1.22-alpine AS builder

WORKDIR /app

RUN apk update && apk add --no-cache git

# Clone source
RUN git clone https://gitlab.adinusa.id/bta-adinusa/notes-wiki.git .

# Build binary
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$(go env GOARCH) go build -o web main.go

# ---------- Runtime stage ----------
FROM alpine:3.19

LABEL maintainer="username_adinusa"

WORKDIR /app

COPY --from=builder /app/web /app/web

EXPOSE 8686

CMD ["/app/web"]

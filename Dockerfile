# ---------- Build stage ----------
FROM golang:1.22-alpine AS builder

WORKDIR /build

RUN apk update && apk add --no-cache git

# Clone source
RUN git clone https://gitlab.adinusa.id/bta-adinusa/notes-wiki.git .

# Download deps & build
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o web main.go

# ---------- Runtime stage ----------
FROM alpine:3.19

LABEL maintainer="username_adinusa"

WORKDIR /app

# Copy binary
COPY --from=builder /build/web /app/web

# 🔥 PENTING: copy template & asset
COPY --from=builder /build/template /app/template
COPY --from=builder /build/static /app/static

EXPOSE 8686

CMD ["/app/web"]

FROM --platform=$BUILDPLATFORM golang:alpine as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM

ENV CGO_ENABLED=0 GOOS=linux

WORKDIR /app

COPY . .

RUN apk add --update-cache ca-certificates tzdata && \
    go mod vendor && \
    rm -rf /var/cache/apk/*

RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        go build -o copilot-gpt4-service .; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        GOARCH=arm64 go build -o copilot-gpt4-service .; \
    elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then \
        GOARCH=arm go build -o copilot-gpt4-service .; \
    else \
        echo "Unsupported platform: $TARGETPLATFORM"; \
        exit 1; \
    fi


FROM scratch

WORKDIR /app

COPY --from=builder /app/copilot-gpt4-service .
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 8080

CMD ["./copilot-gpt4-service"]

FROM --platform=$BUILDPLATFORM golang:alpine as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM

ENV CGO_ENABLED=1 GOOS=linux

WORKDIR /app

# Duplicate the application code.
COPY . .

RUN apk update && apk upgrade && apk add build-base

RUN go mod vendor

# Construct the application.
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

# Second phase: Execution phase.
FROM alpine:latest

WORKDIR /app

# Duplicate the built binary file from the first phase.
COPY --from=builder /app/copilot-gpt4-service .

# Expose the necessary ports required by the application.
EXPOSE 8080

# Execute the application.
CMD ["./copilot-gpt4-service"]

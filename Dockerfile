FROM --platform=$BUILDPLATFORM golang:1.22.1 as builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /go/src/app
COPY . .

RUN make build -e OS=$TARGETOS -e ARCH=$TARGETARCH

FROM scratch

WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs

ENTRYPOINT ["./kbot", "start"]
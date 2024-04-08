FROM --platform=$BUILDPLATFORM golang:1.22.1 as builder

ARG TARGETARCH
ARG TARGETOS
ARG VERSION

WORKDIR /go/src/app
COPY . .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/vit-um/kbot/cmd.appVersion=${VERSION}

FROM scratch

WORKDIR /
COPY --from=builder /go/src/app/kbot .
#COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs

ENTRYPOINT ["./kbot"]
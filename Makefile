APP=$(shell basename $(shell git remote get-url origin) | cut -d '.' -f 1)
REGISTRY=ghcr.io/telest0
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
OS=linux
ARCH=$(shell dpkg --print-architecture)

format:
	gofmt -s -w ./

image:
	docker build --build-arg="TARGETOS=${OS}" --build-arg="TARGETARCH=${ARCH}" -t ${REGISTRY}/${APP}:${VERSION}-${OS}-${ARCH} .
	
push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${OS}-${ARCH}

lint:
	golint

test:
	go test -v

clean:
	rm -rf kbot

linux: 
	docker buildx build -t ${REGISTRY}/${APP}:${VERSION} --platform=linux/amd64,linux/arm64,linux/arm/v7 --push --build-arg VERSION=${VERSION} .

macos:
	docker buildx build -t ${REGISTRY}/${APP}:${VERSION} --platform=darwin/arm64 --push --build-arg VERSION=${VERSION} .

windows:
	docker buildx build -t ${REGISTRY}/${APP}:${VERSION} --platform=windows/amd64 --push --build-arg VERSION=${VERSION} .

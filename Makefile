APP=$(shell basename $(shell git remote get-url origin) | cut -d '.' -f 1)
REGISTRY=telest0
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

format:
	gofmt -s -w ./

image:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-amd64 .
	
push: format image
	docker push ${REGISTRY}/${APP}:${VERSION}-amd64

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

APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=telest0
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

format:
	gofmt -s -w ./

image:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-linux .
	
push:
	docker push ${REGISTRY}/${APP}:${VERSION}-linux

lint:
	golint

test:
	go test -v

clean:
	rm -rf kbot

linux: 
	docker buildx build -t ${REGISTRY}/${APP}:${VERSION}-lin --platform=linux/amd64,linux/arm64,linux/arm/v7 --push .

macos:
	docker buildx build -t ${REGISTRY}/${APP}:${VERSION}-mac --platform=darwin/arm64 --push .

windows:
	docker buildx build -t ${REGISTRY}/${APP}:${VERSION}-win --platform=windows/amd64 --push .

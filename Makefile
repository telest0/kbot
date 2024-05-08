APP=$(shell basename $(shell git remote get-url origin) | cut -d '.' -f 1)
REGISTRY=telest0
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
OS = linux
ARCH = $(shell dpkg --print-architecture)

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

build: 
	CGO_ENABLED=0 GOOS=${OS} GOARCH=${ARCH} go build -v -o kbot -ldflags "-X="github.com/telest0/kbot/cmd.appVersion=${VERSION}

image: build
	docker build --build-arg TARGETOS=${OS} --build-arg TARGETARCH=${ARCH} -t ${REGISTRY}/${APP}:${VERSION}-${OS}-${ARCH} .
	
push: image
	docker push ${REGISTRY}/${APP}:${VERSION}-${OS}-${ARCH}

clean:
	rm -rf kbot
	
output:
	echo "OS: ${OS}"
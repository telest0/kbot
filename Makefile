APP=$(shell basename $(shell git remote get-url origin) | cut -d '.' -f 1)
REGISTRY=telest0
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
OS = linux
ARCH = $(shell dpkg --print-architecture)

format:
	gofmt -s -w ./

image:
	docker build --build-arg TARGETOS=${OS} --build-arg TARGETARCH=${ARCH} -t ${REGISTRY}/${APP}:${VERSION}-${OS}-${ARCH} .
	
push: image
	docker push ${REGISTRY}/${APP}:${VERSION}-${OS}-${ARCH}

lint:
	golint ./

test:
	go test -v

clean:
	rm -rf kbot

build: 
	CGO_ENABLED=0 GOOS=${OS} GOARCH=${ARCH} go build -v -o kbot -ldflags "-X="github.com/telest0/kbot/cmd.appVersion=${VERSION}

output:
	echo "OS: ${OS}"

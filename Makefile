.PHONY: all build bench test cover fmt race cpuprof memprof 

TIMESTAMP = $(shell date +"%Y-%m-%d_%H-%M-%S")
PKG = $(shell go list ./... | grep -v /vendor/)

all: install lint build test cover

install:
	go get github.com/golang/lint/golint
	go get golang.org/x/tools/cmd/cover

build:
	go build ${PKG}

bench:
	go test -bench=. -benchmem ${PKG}

test:
	go test -v ${PKG}

cover:
	echo "" > coverage.txt
	for d in ${PKG}; \
		do echo "" > profile.out; \
		go test -coverprofile=profile.out -covermode=set $$d; \
		cat profile.out >> coverage.txt; \
		rm profile.out; \
	done

fmt:
	gofmt -l -w *.go

lint:
	golint ${PKG}
	go vet ${PKG}

race:
	go test -race ${PKG}

cpuprof:
	go test -cpuprofile cpu-${TIMESTAMP}.prof ${PKG}

memprof:
	go test -memprofile mem-${TIMESTAMP}.prof ${PKG}
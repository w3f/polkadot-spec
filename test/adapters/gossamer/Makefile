.PHONY: all build install clean

all: install

build:
	go build -v

install: build
	cp gossamer-adapter ../../bin/

clean:
	rm -f gossammer-adapter

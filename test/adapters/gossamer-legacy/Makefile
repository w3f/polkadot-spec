.PHONY: all build install version clean

all: install

build:
	go build -v

install: build
	cp gossamer-adapter-legacy ../../bin/
	cp ~/go/pkg/mod/github.com/wasmerio/go-ext-wasm@*/wasmer/libwasmer.so ../../lib/
	chmod u+w ../../lib/libwasmer.so

clean:
	rm -f gossamer-adapter-legacy

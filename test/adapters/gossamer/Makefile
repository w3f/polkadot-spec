.PHONY: all build install version clean

all: install

build:
	go build -v

install: build
	cp gossamer-adapter ../../bin/
	cp ~/go/pkg/mod/github.com/wasmerio/go-ext-wasm@*/wasmer/libwasmer.so ../../lib/
	chmod u+w ../../lib/libwasmer.so

version:
	@grep "github.com/ChainSafe/gossamer" go.mod | cut -d' ' -f2

clean:
	rm -f gossamer-adapter

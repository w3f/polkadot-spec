.PHONY: all build install clean

all: install

build:
	go build -v

install: build
	cp gossamer-adapter ../../bin/

# After host-api implementation, add:
# cp ~/go/pkg/mod/github.com/wasmerio/go-ext-wasm@*/wasmer/libwasmer.so ../../lib/

clean:
	rm -f gossammer-adapter

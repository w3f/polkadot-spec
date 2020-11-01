.PHONY: all build install clean

all: install

build:
	cargo build --release

install: build
	cp target/release/wbuild/hostapi-runtime/hostapi_runtime.compact.wasm ../../bin/

clean:
	rm -rf target

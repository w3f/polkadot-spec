.PHONY: all build install clean

all: install

build:
	cargo build --release

install: build
	cp target/release/wbuild/hostapi-runtime-legacy/hostapi_runtime_legacy.compact.wasm ../../bin/

clean:
	rm -rf target

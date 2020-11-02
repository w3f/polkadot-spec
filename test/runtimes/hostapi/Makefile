.PHONY: all build install version clean

all: install

build:
	cargo build --release

install: build
	cp target/release/wbuild/hostapi-runtime/hostapi_runtime.compact.wasm ../../bin/

version:
	@echo "Unknown"

clean:
	rm -rf target

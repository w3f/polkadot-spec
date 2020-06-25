.PHONY: all build install clean

all: install

build:
	cargo build --release

install: build
	cp target/release/wbuild/wasm-adapter-legacy/wasm_adapter_legacy.compact.wasm ../../bin/

clean:
	rm -rf target

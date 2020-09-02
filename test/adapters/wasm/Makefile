.PHONY: all build install clean

all: install

build:
	cargo build --release

install: build
	cp target/release/wbuild/wasm-adapter/wasm_adapter.compact.wasm ../../bin/

clean:
	rm -rf target

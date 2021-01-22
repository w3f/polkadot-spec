.PHONY: all build install build-expmem install-expmem version clean

all: install

build:
	cargo build --release

install: build
	cp target/release/wbuild/hostapi-runtime/hostapi_runtime.compact.wasm ../../bin/


build-expmem:
	cargo build --features export-memory --release

install-expmem: build-expmem
	cp target/release/wbuild/hostapi-runtime/hostapi_runtime.compact.wasm ../../bin/hostapi_runtime.expmem.compact.wasm


version:
	@echo "Unknown"

clean:
	rm -rf target

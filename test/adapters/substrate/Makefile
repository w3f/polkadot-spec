.PHONY: all build install build-expmem install-expmem version clean

all: install

build:
	cargo build --release

install: build
	cp target/release/substrate-adapter ../../bin/


build-expmem:
	cargo build --features export-memory --release

install-expmem: build-expmem
	cp target/release/substrate-adapter ../../bin/substrate-adapter-expmem


version:
	@cargo metadata --format-version 1 | jq '.packages[] | select(.name=="sp-core").id' | cut -d' ' -f2

clean:
	rm -rf target

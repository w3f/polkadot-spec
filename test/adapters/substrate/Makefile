.PHONY: all build install version clean

all: install

build:
	cargo build --release

install: build
	cp target/release/substrate-adapter ../../bin/

version:
	@cargo metadata --format-version 1 | jq '.packages[] | select(.name=="sp-core").id' | cut -d' ' -f2

clean:
	rm -rf target

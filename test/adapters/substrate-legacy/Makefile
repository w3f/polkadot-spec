.PHONY: all build install version clean

all: install

build:
	cargo build --release

install: build
	cp target/release/substrate-adapter-legacy ../../bin/

version:
	@cargo metadata --format-version 1 | jq '.packages[] | select(.name=="substrate-primitives").id' | grep -o -E "[0-9a-f]{40}"

clean:
	rm -rf target

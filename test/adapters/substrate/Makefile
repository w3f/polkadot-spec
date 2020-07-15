.PHONY: all build install clean

all: install

build:
	cargo build --release

install: build
	cp target/release/substrate-adapter ../../bin/

clean:
	rm -rf target

.PHONY: all build version clean

all: genesis.json genesis.yaml

build:
	cargo build --release

genesis.json: build
	cargo run --release > $@

genesis.yaml: genesis.json
	yq -y < $< '.genesis.raw.top | { keys: keys_unsorted | map(.[2:]), values: map(.[2:]) }' > $@

version:
	@cargo metadata --format-version 1 | jq '.packages[] | select(.name=="sp-core").id' | cut -d' ' -f2

clean:
	rm -rf target genesis.json genesis.yaml

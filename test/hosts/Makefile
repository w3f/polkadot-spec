.PHONY: all substrate kagome gossamer sync sync-adapter-substrate sync-runtime-tester version clean


all: substrate kagome gossamer


substrate:
	cd substrate && cargo build --release
	cp substrate/target/release/polkadot ../bin/

kagome:
	cmake -DCMAKE_BUILD_TYPE=Release -S kagome -B kagome/build
	cmake --build kagome/build
	cp kagome/build/node/kagome_validating/kagome_validating           ../bin/
	cp kagome/build/node/kagome_full_syncing/kagome_full_syncing       ../bin/

gossamer:
	cd gossamer && go build -v ./cmd/gossamer
	cp gossamer/gossamer ../bin/
	cp ~/go/pkg/mod/github.com/wasmerio/go-ext-wasm@*/wasmer/libwasmer.so ../lib/
	chmod u+w ../lib/libwasmer.so


sync: sync-adapter-substrate sync-runtime-tester

sync-adapter-substrate:
	cp substrate/Cargo.lock ../adapters/substrate/
	cargo metadata --manifest-path ../adapters/substrate/Cargo.toml > /dev/null

sync-runtime-tester:
	cp substrate/Cargo.lock ../runtimes/tester
	cargo metadata --manifest-path ../runtimes/tester/Cargo.toml > /dev/null


version:
	@echo "substrate-host: $$(cd substrate && git describe)"
	@echo "kagome-host: $$(cd kagome && git describe)"
	@echo "gossamer-host: $$(cd gossamer && git describe --tags)"

clean:
	rm -rf substrate/target
	rm -rf kagome/build
	rm  -f gossamer/gossamer

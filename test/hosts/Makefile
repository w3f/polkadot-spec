.PHONY: all substrate kagome gossamer clean


all: substrate kagome gossamer


substrate:
	cd substrate && cargo build --release
	cp substrate/target/release/polkadot ../bin/

kagome:
	cmake -DCMAKE_BUILD_TYPE=Release -S kagome -B kagome/build
	cmake --build kagome/build
	cp kagome/build/node/kagome_validating/kagome_validating           ../bin/
	cp kagome/build/node/kagome_full_syncing/kagome_full_syncing       ../bin/
	cp kagome/build/node/kagome_block_producing/kagome_block_producing ../bin/

gossamer:
	cd gossamer && go build -v ./cmd/gossamer
	cp gossamer/gossamer ../bin/
	cp ~/go/pkg/mod/github.com/wasmerio/go-ext-wasm@*/wasmer/libwasmer.so ../lib/

clean:
	rm -rf substrate/target
	rm -rf kagome/build
	rm  -f gossamer/gossamer

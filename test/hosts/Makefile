.PHONY: all substrate-host kagome-host gossamer-host

all: substrate-host kagome-host gossamer-host

substrate-host:
	cd substrate && cargo build --release

kagome-host:
	cmake -DCMAKE_BUILD_TYPE=Release -S kagome -B kagome/build
	cmake --build kagome/build

gossamer-host:
	cd gossamer && go build -v ./cmd/gossamer

clean:
	rm -rf substrate/target
	rm -rf kagome/build
	rm -f gossamer/gossamer

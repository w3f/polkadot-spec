module w3f/gossamer-adapter

require (
	github.com/ChainSafe/chaindb v0.1.5-0.20210117220933-15e75f27268f
	github.com/ChainSafe/gossamer v0.2.1-0.20210115002259-7c0a61a29bc6
	github.com/DataDog/zstd v1.4.5 // indirect
	github.com/OneOfOne/xxhash v1.2.8 // indirect
	github.com/btcsuite/btcd v0.21.0-beta // indirect
	github.com/dgraph-io/ristretto v0.0.3 // indirect
	github.com/dgryski/go-farm v0.0.0-20200201041132-a6ae2369ad13 // indirect
	github.com/ethereum/go-ethereum v1.9.20 // indirect
	github.com/go-yaml/yaml v2.1.0+incompatible
	github.com/mattn/go-colorable v0.1.8 // indirect
	github.com/multiformats/go-multiaddr v0.3.1 // indirect
	gopkg.in/yaml.v3 v3.0.0-20200615113413-eeeca48fe776 // indirect
)

replace github.com/ChainSafe/gossamer => ../../hosts/gossamer

go 1.14

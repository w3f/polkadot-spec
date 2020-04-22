{ lib, rustWasmPlatform, protobuf }:

rustWasmPlatform.buildRustPackage {
  name = "substrate-adapter";

  src = lib.cleanSource ./.;

  cargoSha256 = "0xzg2x4j7wcdmjf5b91aapld18x6whx92s85dnd26ckhs03xqy48";

  buildInputs = [ protobuf ];

  # Needed to build rust-libp2p
  PROTOC         = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  # Fix to allows direct use of wasm-builder for no_std binaries
  # https://doc.rust-lang.org/nightly/cargo/reference/unstable.html#features
  cargoBuildFlags = [ "-Zfeatures=build_dep" ];
}

{ lib, rustWasmPlatform, protobuf }:

rustWasmPlatform.buildRustPackage {
  name = "substrate-adapter";

  src = lib.cleanSource ./.;

  cargoSha256 = "0x8q51nx7zdi7gn2a0c2fl97b5kdzrnacvh0ins5h98r1ign4mhm";

  buildInputs = [ protobuf ];

  # Needed to build rust-libp2p
  PROTOC         = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  # Fix to allows direct use of wasm-builder for no_std binaries (broken? does not do anything under nix)
  # https://doc.rust-lang.org/nightly/cargo/reference/unstable.html#features
  #cargoBuildFlags = [ "-Zfeatures=build_dep" ];
}

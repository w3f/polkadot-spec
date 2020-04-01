{ rustWasmPlatform, protobuf }:

rustWasmPlatform.buildRustPackage {
  name = "rust_tester";

  src = ./.;

  cargoSha256 = "1v3z912cn1blyhjh2shcya3xdfvhd5piwi4bxm1b1wnwbw62a8fc";

  buildInputs = [ protobuf ];

  # Needed to build rust-libp2p
  PROTOC         = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  # Fix to allows direct use of wasm-builder for no_std binaries
  cargoBuildFlags = [ "-Z features=build_dep" ];
}

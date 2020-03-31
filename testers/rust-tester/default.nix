{ rustWasmPlatform, protobuf }:

rustWasmPlatform.buildRustPackage {
  name = "rust_tester";

  src = ./.;

  cargoSha256 = "1hl97rxxj6nkmz2v1ahd2bckgyk3yr5dqga732537ri00n84d47i";

  buildInputs = [
    protobuf
  ];

  PROTOC         = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  # This way we can use wasm-builder directly
  extraRustcOpts = "-Z features=build_dep";
}

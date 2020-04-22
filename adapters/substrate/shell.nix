{ pkgs ? import <nixpkgs> {} }:
 
with pkgs; mkShell {
  name = "substrate-adapter";

  nativeBuildInputs = [ rustWasmPlatform.rust.cargo ];
  buildInputs = [ protobuf ];

  PROTOC         = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";
}

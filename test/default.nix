{ pkgs ? import <nixpkgs> {} }:

with pkgs; {
  # Derivations of adapter binaries used by test suite 
  substrate-adapter = callPackage ./adapters/substrate {};
  gossamer-adapter  = callPackage ./adapters/gossamer {};
  kagome-adapter    = callPackage ./adapters/kagome {};
}

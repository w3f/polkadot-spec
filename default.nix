{ pkgs ? import <nixpkgs> {} }:

with pkgs; {
  # Derivations of tester binaries used by test suite 
  rust-tester = callPackage ./testers/rust-tester {};
  go-tester   = callPackage ./testers/go-tester {};
  cpp-tester  = callPackage ./testers/cpp-tester {};
}

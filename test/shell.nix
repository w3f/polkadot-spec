{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "spectest-env";

  # Include julia to run the test harness
  nativeBuildInputs = [ pkgs.julia ];

  # Include all the builder defined in default.nix
  buildInputs = builtins.attrValues
    (import ./default.nix { inherit pkgs; });
}

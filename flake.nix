{
  description = "Polkadot Protocol Specification";

  inputs = {
    # Nix base libraries
    utils.url = "github:numtide/flake-utils";

    # Basis for included packages
    nixpkgs.url = "github:nixos/nixpkgs/release-20.09";
  };

  outputs = { self, utils, nixpkgs } :
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";

        src = self;

        version = if self ? rev then (builtins.substring 0 7 self.rev)
                  else if self ? lastModifiedDate then self.lastModifiedDate
                  else "dirty";

        texlive-spec = pkgs.callPackage ./.nix/texlive.nix {
          extraTexPackages = {
            inherit (pkgs.texlive) latexmk algorithms algorithmicx luacode;
          };
        };
      in {
        packages = {
          polkadot-host-spec    = pkgs.callPackage ./.nix/host-spec.nix { inherit src version; };
          polkadot-runtime-spec = pkgs.callPackage ./.nix/runtime-spec.nix { inherit src version texlive-spec; };
        };

        devShell = pkgs.mkShell {
          pname = "polkadot-spec-env";
          inherit version;

          inputsFrom = builtins.attrValues self.packages."${system}";
          buildInputs = [ pkgs.gnumake ];
        };
      }) // {
        checks = self.packages;
      };
}

{
  description = "Polkadot Protocol Specification";

  inputs = {
    # Nix base libraries
    utils.url = "github:numtide/flake-utils";

    # Basis for included packages
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
  };

  outputs = { self, utils, nixpkgs } :
    utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";

        src = self;

        version = if self ? rev then (builtins.substring 0 7 self.rev)
                  else if self ? lastModifiedDate then self.lastModifiedDate
                  else "dirty";

        algorithmacs = pkgs.callPackage ./.nix/algorithmacs.nix {};

        host-spec-pkgs = pkgs.callPackage ./.nix/host-spec.nix { inherit src version algorithmacs; };

        texlive-spec = pkgs.callPackage ./.nix/texlive.nix {
          extraTexPackages = {
            inherit (pkgs.texlive) latexmk algorithms algorithmicx luacode;
          };
        };
      in {
        packages = host-spec-pkgs // {
          runtime-spec = pkgs.callPackage ./.nix/runtime-spec.nix { inherit src version texlive-spec; };
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

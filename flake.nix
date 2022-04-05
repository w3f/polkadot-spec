{
  description = "Polkadot Protocol Specification";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = "https://polkadot-spec.cachix.org";
    extra-trusted-public-keys = "polkadot-spec.cachix.org-1:tQiTEmNIdQ+aEV0zrfdrCn8bQZo/spEMAFGH8YEidQU=";
  };

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
  };

  outputs = { self, utils, nixpkgs }: utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};

    ruby = pkgs.ruby_3_0;
    gemConfig = pkgs.defaultGemConfig.override { inherit ruby; };
    
    gems = extraGroup: pkgs.bundlerEnv {
      name = "polkadot-spec-gems";
      inherit ruby gemConfig;
      gemdir  = ./.;
      groups = [ "default" ] ++ nixpkgs.lib.optional (extraGroup != "") extraGroup; 
    };

    bundleExec = extraGroup: "${(gems extraGroup)}/bin/bundle exec";
  in {
    packages = {
      html = pkgs.runCommand "polkadot-spec.html" {} ''
        ${bundleExec ""} asciidoctor -r ${self}/asciidoctor-pseudocode.rb -o $out ${self}/index.adoc
      '';
      
      pdf = pkgs.runCommand "polkadot-spec.pdf" { BUNDLE_WITH = "pdf"; } ''
        ${bundleExec "pdf"} asciidoctor-pdf -a imagesoutdir=$(mktemp -d) -r asciidoctor-mathematical -o $out ${self}/index.adoc
      ''; 
    };

    devShell = pkgs.mkShell {
      buildInputs = [
        ruby.devEnv
      ] ++ (with pkgs; [
        cmake
        pkg-config
    
        bison
        cairo
        flex
        gdk-pixbuf 
        gnome.gobject-introspection
        libxml2
        pango
      ]);
    };

    defaultPackage = self.packages.${system}.html;
  }) // {
    checks = self.packages;
  };
}

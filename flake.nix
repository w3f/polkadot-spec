{
  description = "Polkadot Protocol Specification";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = "https://polkadot-spec.cachix.org";
    extra-trusted-public-keys = "polkadot-spec.cachix.org-1:tQiTEmNIdQ+aEV0zrfdrCn8bQZo/spEMAFGH8YEidQU=";
  };

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, utils, nixpkgs }: utils.lib.eachSystem [ "aarch64-linux" "i686-linux" "x86_64-linux"] (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    lib = nixpkgs.lib;

    ruby = pkgs.ruby_3_1;
    gemConfig = pkgs.defaultGemConfig.override { inherit ruby; } // {
      wkhtml = attrs: {
        buildInputs = [ pkgs.wkhtmltopdf ];
      };
    };

    gems = extraGroup: pkgs.bundlerEnv {
      name = "polkadot-spec-gems";
      inherit ruby gemConfig;
      gemdir  = ./.;
      groups = [ "default" ] ++ lib.optional (extraGroup != "") extraGroup;
    };

    bundleExec = extraGroup: "${(gems extraGroup)}/bin/bundle exec";

    buildInputs = with pkgs; [ kaitai-struct-compiler graphviz ];

    # Needed by wkhtml to us QT offscreen render
    QT_PLUGIN_PATH = with pkgs.qt514.qtbase; "${bin}/${qtPluginPrefix}";
    QT_QPA_PLATFORM = "offscreen";

    # Shared command line args
    sharedArgs = "-r ${self}/asciidoctor-pseudocode.rb -r ${self}/asciidoctor-kaitai.rb -o $out --trace ${self}/polkadot-spec.adoc";

    # Ruby Ghostscript detection is unreliable
    GS = "${pkgs.ghostscript}/bin/gs";
  in {
    packages = rec {
      default = html;

      html = pkgs.runCommand "polkadot-spec.html" { inherit buildInputs; } ''
        ${bundleExec ""} asciidoctor -r ${self}/asciidoctor-mathjax3.rb ${sharedArgs}
      '';

      pdf = pkgs.runCommand "polkadot-spec.pdf" { BUNDLE_WITH = "pdf"; inherit buildInputs QT_PLUGIN_PATH QT_QPA_PLATFORM GS; } ''
        export HOME=$(mktemp -d)
        mkdir -p $HOME/.local
        ln -s ${pkgs.bakoma_ttf}/share $HOME/.local/
        ${bundleExec "pdf"} asciidoctor-pdf -a imagesoutdir=$(mktemp -d) -r asciidoctor-mathematical ${sharedArgs}
      '';
    };

    devShells.default = pkgs.mkShell {
      buildInputs = [
        ruby.devEnv
      ] ++ (with pkgs; [
        cmake
        pkg-config

        bakoma_ttf
        bison
        cairo
        flex
        gdk-pixbuf 
        ghostscript
        gobject-introspection
        libxml2
        pango

        wkhtmltopdf
      ]) ++ buildInputs;

      inherit QT_PLUGIN_PATH QT_QPA_PLATFORM GS;
    };
  }) // {
    checks = self.packages;
  };
}

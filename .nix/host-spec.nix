{ src, version, stdenv, texmacs, plantuml, xvfb_run, algorithmacs }:

let
  mkHostSpec = format: stdenv.mkDerivation {
    name = "polkadot-host-spec-${version}.${format}";

    inherit src version;

    sourceRoot = "source/host-spec";

    nativeBuildInputs = [
      texmacs
      plantuml
      xvfb_run
    ];

    phases = [ "unpackPhase" "buildPhase" "installPhase" ];

    buildFlags = [ format ];

    preBuild = ''
      export HOME=$(mktemp -d)
      install -Dt $HOME/.TeXmacs/packages ${algorithmacs}
    '';

    installPhase = "cp polkadot-host-spec.${format} $out";
  };

  mkNamedDrvPair = format: let
    escaped = builtins.replaceStrings ["."] ["-"] format;
  in { 
    name = "host-spec-${escaped}"; 
    value = mkHostSpec format; 
  };

  formats = [ "pdf" "tex" "html.tar.gz" "tmml" ];
in
  builtins.listToAttrs (map mkNamedDrvPair formats)

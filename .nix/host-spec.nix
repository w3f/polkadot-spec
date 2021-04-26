{ src, version, stdenv, texmacs, plantuml, xvfb_run, algorithmacs }:

stdenv.mkDerivation {
  name = "polkadot-host-spec-${version}.pdf";

  inherit src version;

  sourceRoot = "source/host-spec";

  nativeBuildInputs = [
    texmacs
    plantuml
    xvfb_run
  ];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  preBuild = ''
    export HOME=$(mktemp -d)
    install -Dt $HOME/.TeXmacs/packages ${algorithmacs}
  '';

  installPhase = ''
    cp polkadot-host-spec.pdf $out
  '';
}

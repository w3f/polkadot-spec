{ src, version, stdenv, texmacs, xvfb_run }:

stdenv.mkDerivation {
  name = "polkadot-host-spec-${version}.pdf";

  inherit src version;

  sourceRoot = "source/host-spec";

  nativeBuildInputs = [
    texmacs
    xvfb_run
  ];

  phases = [ "unpackPhase" "convertPhase" ];

  convertPhase = ''
    export HOME=$(mktemp -d)
    xvfb-run texmacs -b host-spec.scm -x '(convert-updated "$PWD/host-spec.tm" "$out")' --quit
  '';
}

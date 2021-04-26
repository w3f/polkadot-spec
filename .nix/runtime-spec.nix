{ src, version, stdenv, texlive-spec, plantuml, graphviz }:

stdenv.mkDerivation {
  name = "polkadot-runtime-spec-${version}.pdf";

  inherit src version;

  sourceRoot = "source/runtime-spec";

  nativeBuildInputs = [
    texlive-spec
    plantuml
    graphviz
  ];

  PLANTUML_JAR = "${plantuml}/lib/plantuml.jar";

  buildPhase = ''
    export HOME=$(mktemp -d)
    latexmk -pdflua runtime-spec.tex
  '';

  installPhase = ''
    cp runtime-spec.pdf $out
  '';
}

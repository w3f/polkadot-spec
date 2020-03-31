{ stdenv, cmake, kagome, libyamlcpp }:

stdenv.mkDerivation {
  name = "cpp-tester";

  src = ./.;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ kagome libyamlcpp ];
}

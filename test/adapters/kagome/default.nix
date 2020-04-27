{ lib, stdenv, cmake, kagome, libyamlcpp }:

stdenv.mkDerivation {
  name = "kagome-adapter";

  src = lib.cleanSource ./.;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ kagome libyamlcpp ];

  cmakeFlags = [ "-DHUNTER_ENABLED=ON" ];
}

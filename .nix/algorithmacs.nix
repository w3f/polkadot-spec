{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "algorithmacs-style-${builtins.substring 0 7 version}.ts";
  version = "ad3544683d2e8e9358bf40acb826b3d55c52ed86";

  src = fetchFromGitHub {
    owner = "w3f";
    repo = "algorithmacs";
    rev = version;
    sha256 = "038fxxdn25gv6w9kv30p8vzpm9hqdm00kwmvmap0rxazf9ba23fa";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = "cp algorithmacs-style.ts $out";
}

{ lib, buildGoModule }:

buildGoModule rec {
  name = "gossamer-adapter";

  src = lib.cleanSource ./.;

  modSha256 = "0x404s1wdpy7qniha5i593x4q24gcwn9xmcqyby70xp646fm3qjf";
}

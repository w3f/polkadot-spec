{ buildGoModule }:

buildGoModule rec {
  name = "go-tester";

  src = ./.;

  modSha256 = "0x404s1wdpy7qniha5i593x4q24gcwn9xmcqyby70xp646fm3qjf";
}

{ buildGoModule }:

buildGoModule rec {
  name = "go-tester";

  src = ./.;

  modSha256 = "1hj59isnhz8f26b3g681mcxdzggid4zkjv4p8ba7cb4nrdp72vhz";
}

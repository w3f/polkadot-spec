let
  w3fpkgs = builtins.fetchTarball {
    name = "w3fpks-2020-04-28";
    url = https://gitlab.w3f.tech/florian/w3fpkgs/-/archive/768c313dcbcd602c10c734f7890417cf6dda46b3.tar.gz;
    sha256 = "1zmvwdpzjn547x5cn58p45z8dm4j9s30f3k829x2ivcs6gghdyxm";
  };
in
  import "${w3fpkgs}/release.nix"

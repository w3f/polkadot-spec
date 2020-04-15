let
  w3fpkgs = builtins.fetchTarball {
    name = "w3fpks-2020-04-15";
    url = https://gitlab.w3f.tech/florian/w3fpkgs/-/archive/c4fffd253eb3804847b0fe7f36facaf6bb2401cf.tar.gz;
    sha256 = "1slzzn8rw1n26d7nc7ypnk1d4vfjrflk0yiff14nxwwx9a91qadw";
  };
in
  import "${w3fpkgs}/release.nix"

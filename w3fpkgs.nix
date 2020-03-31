let
  w3fpkgs = builtins.fetchTarball {
    name = "w3fpks-2020-03-29";
    url = https://gitlab.w3f.tech/florian/w3fpkgs/-/archive/58ce02e73380b9b5dae78fb6f4ec87dec9241add.tar.gz;
    sha256 = "09067ga7b88v9h0jk8dvxpl9x28wvgh52xk7sfwj4a61hl8h8nzh";
  };
in
  import "${w3fpkgs}/release.nix"

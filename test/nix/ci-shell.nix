{ jobid }:

let
  # Import pinned packages and adapters
  pkgs    = import ./w3fpkgs.nix;
  adapter = import ../default.nix { inherit pkgs; };

  # Parse job id
  split = builtins.split " " jobid;

  fix  = builtins.head (builtins.tail (builtins.tail split));
  impl = builtins.head split;

  # Resolve dependecies
  impldeps = {
    substrate = [ adapter.substrate-adapter ];
    kagome    = [ adapter.kagome-adapter ];
    gossamer  = [ adapter.gossamer-adapter ];
  };

  fixdeps = {
    scale-codec = [ adapter.substrate-adapter ];
    state-trie  = [ adapter.substrate-adapter ];
  };

  deps = (fixdeps.${fix} or []) ++ (impldeps.${impl} or []);
in
  pkgs.mkShell {
    name = "spectest-ci-env";

    # Include julia to run the test harness
    nativeBuildInputs = [ pkgs.julia ];

    # Include all the builder defined in default.nix
    buildInputs = deps;
  }

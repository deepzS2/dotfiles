{
  perSystem = {pkgs, ...}: {
    devshells.default = {
      packages = builtins.attrValues {inherit (pkgs) alejandra nil statix deadnix git jq yq tree;};
      commands = [
        {
          category = "styling";
          help = "run deadnix and statix checks";
          name = "lint";
          command = "statix check $PRJ_ROOT && deadnix $PRJ_ROOT";
        }
        {
          category = "styling";
          help = "run nix fmt";
          name = "fmt";
          command = "nix fmt $PRJ_ROOT";
        }
        {
          category = "flake";
          help = "run a flake check";
          name = "check";
          command = "nix flake check";
        }
        {
          category = "flake";
          help = "run a flake update for all inputs or by provided in arguments";
          name = "update";
          command = "nix flake update $*";
        }
        {
          category = "testing";
          help = "run an nixos test for specified user";
          name = "test";
          command = ''
            #!/usr/bin/env bash

            git add .
            nh os test -H $1
          '';
        }
        {
          category = "testing";
          help = "run an nixos rebuild switch";
          name = "switch";
          command = ''
            #!/usr/bin/env bash

            git add .
            nh os switch -H $1
          '';
        }
        {
          category = "testing";
          help = "run an nixos build virtual machine";
          name = "vm";
          command = ''
            #!/usr/bin/env bash

            git add .
            nh os build-vm -H $1
          '';
        }
        {
          category = "misc";
          help = "prefetch url and get the sha256 hash";
          name = "fetch-url-hash";
          command = ''
            #!/usr/bin/env bash

            nix hash convert --hash-algo sha256 $(nix-prefetch-url $1)
          '';
        }
      ];
    };
  };
}

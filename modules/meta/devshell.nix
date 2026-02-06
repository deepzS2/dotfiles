{
  perSystem = {pkgs, ...}: {
    devshells.default = {
      packages = builtins.attrValues {inherit (pkgs) alejandra nil statix deadnix git jq yq tree nix-inspect;};
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
          category = "repl";
          help = "TUI repl inspector";
          name = "inspector";
          command = "nix-inspect --expr \"builtins.getFlake \\\"$PRJ_ROOT\\\"\"";
        }
        {
          category = "repl";
          help = "Execute nix repl on the flake";
          name = "repl";
          command = ''
            #!/usr/bin/env bash

            TARGET="nixos"
            HOST=""

            while [[ $# -gt 0 ]]; do
              case $1 in
                --target)
                  TARGET="$2"
                  shift 2
                  ;;
                --target=*)
                  TARGET="''${1#*=}"
                  shift
                  ;;
                -*)
                  echo "Unknown option: $1"
                  exit 1
                  ;;
                *)
                  HOST="$1"
                  shift
                  ;;
              esac
            done

            if [ "$TARGET" = "nixos" ]; then
              nh os repl -H "$HOST"
            else
              nh home repl -c "$HOST"
            fi
          '';
        }
        {
          category = "building";
          help = "run an nixos build and activate";
          name = "trybuild";
          command = ''
            #!/usr/bin/env bash

            git add .
            nh os test -H $1 -d always
          '';
        }
        {
          category = "building";
          help = "run an nixos/home rebuild switch";
          name = "switch";
          command = ''
            #!/usr/bin/env bash

            TARGET="nixos"
            HOST=""

            while [[ $# -gt 0 ]]; do
              case $1 in
                --target)
                  TARGET="$2"
                  shift 2
                  ;;
                --target=*)
                  TARGET="''${1#*=}"
                  shift
                  ;;
                -*)
                  echo "Unknown option: $1"
                  exit 1
                  ;;
                *)
                  HOST="$1"
                  shift
                  ;;
              esac
            done

            git add .

            if [ "$TARGET" = "nixos" ]; then
              nh os switch -H "$HOST" -d always
            else
              nh home switch -c "$HOST" -d always
            fi
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

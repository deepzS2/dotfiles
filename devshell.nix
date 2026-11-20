{
  pkgs,
  inputs',
  ...
}: {
  devShells.default = inputs'.devshell.mkShell {
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

          HOST=""

          while [[ $# -gt 0 ]]; do
            case $1 in
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

          nh os repl -H "$HOST"
        '';
      }
      {
        category = "building";
        help = "run an nixos rebuild switch";
        name = "switch";
        command = ''
          #!/usr/bin/env bash

          HOST=""

          while [[ $# -gt 0 ]]; do
            case $1 in
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

          nh os switch -H "$HOST" -d always
        '';
      }
      {
        category = "building";
        help = "build an nixos boot generation (activates on next reboot)";
        name = "boot";
        command = ''
          #!/usr/bin/env bash

          HOST=""

          while [[ $# -gt 0 ]]; do
            case $1 in
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

          nh os boot -H "$HOST"
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
}

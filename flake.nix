{
  description = "My Nix configuration - by deepz";

  inputs = {
    adios-flake.url = "github:Mic92/adios-flake";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";

    # Hjem
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nvim, Emacs and AI
    nvimz.url = "git+https://codeberg.org/deepzS2/nvimz";
    demacz.url = "git+https://codeberg.org/deepzS2/demacz";
    llm-agents.url = "github:numtide/llm-agents.nix";
    workmux.url = "github:raine/workmux";

    # Window managers
    niri.url = "github:sodiboo/niri-flake";
    niri-scratchpad = {
      url = "github:gvolpe/niri-scratchpad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theming and greetd
    matugen = {
      url = "github:/InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop shell
    sheez = {
      url = "github:deepzS2/sheez";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Cachy kernel patches
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    # Screenshare audio
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
  };

  outputs = inputs @ {
    self,
    adios-flake,
    ...
  }: let
    importTree = import ./lib/import-tree.nix inputs.nixpkgs.lib;
  in
    adios-flake.lib.mkFlake {
      inherit inputs self;
      systems = ["x86_64-linux" "aarch64-linux"];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        formatter = pkgs.alejandra;

        packages = {
          kanagawa-gtk-theme = pkgs.callPackage ./packages/kanagawa-gtk-theme.nix {};
          mister-download-manager = pkgs.callPackage ./packages/mister-download-manager.nix {};
        };

        devShells.default = inputs.devshell.legacyPackages.${system}.mkShell {
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
      };

      flake = {
        nixosConfigurations = {
          tojo = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs self;};

            modules =
              [
                inputs.hjem.nixosModules.default
                ./hosts/tojo
              ]
              ++ importTree ./nixos/core;
          };

          omi = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs self;};

            modules =
              [
                inputs.hjem.nixosModules.default
                ./hosts/omi
              ]
              ++ importTree ./nixos/core;
          };
        };
      };
    };
}

# VSCode configuration module for Home Manager
# Exported as flake.modules.homeManager.vscode
{
  flake.modules.homeManager.vscode = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.editor.vscode;
  in {
    options = {
      editor.vscode = {
        enable = lib.mkEnableOption "Visual Studio Code";

        nix = {
          enableLanguageServer = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable Nix language server";
          };

          serverPath = lib.mkOption {
            type = lib.types.str;
            default = "nixd";
            description = "Path to Nix language server";
          };

          formatterPath = lib.mkOption {
            type = lib.types.str;
            default = "alejandra";
            description = "Path to Nix formatter";
          };
        };

        extraExtensions = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [];
          description = "Extra VSCode extensions to install";
        };

        extraSettings = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = {};
          description = "Extra VSCode user settings";
        };
      };
    };

    config = lib.mkIf cfg.enable {
      home.packages = [
        # Nix IDE
        pkgs.nixd
        pkgs.alejandra
      ];

      programs.vscode = {
        enable = true;
        profiles.default = {
          extensions = with pkgs.vscode-marketplace;
            [
              jnoortheen.nix-ide
              # qufiwefefwoyn.kanagawa
            ]
            ++ cfg.extraExtensions;

          userSettings =
            lib.recursiveUpdate {
              "editor.formatOnSave" = true;

              # Nix
              "nix.enableLanguageServer" = cfg.nix.enableLanguageServer;
              "nix.serverPath" = cfg.nix.serverPath;
              "nix.formatterPath" = cfg.nix.formatterPath;
              "nix.serverSettings" = {
                nixd = {
                  nixpkgs = {
                    expr = "import <nixpkgs> {}";
                  };
                  formatting = {
                    command = [cfg.nix.formatterPath];
                  };
                  options = {
                    nixos = {
                      expr = "(builtins.getFlake \"${config.home.homeDirectory}/.dotfiles\").nixosConfigurations.default.options";
                    };
                    home-manager = {
                      options = "(builtins.getFlake \"${config.home.homeDirectory}/.dotfiles\").nixosConfigurations.default.options.home-manager.users.type.getSubOptions []";
                    };
                  };
                };
              };
            }
            cfg.extraSettings;
        };
      };
    };
  };
}

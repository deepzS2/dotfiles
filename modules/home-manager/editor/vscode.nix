{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.editor.vscode;
in {
  options = {
    editor.vscode.enable = lib.mkEnableOption "Visual Studio Code";
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
        extensions = with pkgs.vscode-marketplace; [
          jnoortheen.nix-ide
          qufiwefefwoyn.kanagawa
        ];
        userSettings = {
          "editor.formatOnSave" = true;

          # Theming
          "workbench.colorTheme" = "Kanagawa";
          "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";

          # Nix
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.formatterPath" = "alejandra";
          "nix.serverSettings" = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> {}";
              };
              formatting = {
                command = ["alejandra"];
              };
              options = {
                nixos = {
                  expr = "(builtins.getFlake \"/home/deepz/.dotfiles\").nixosConfigurations.default.options";
                };
                home-manager = {
                  options = "(builtins.getFlake \"/home/deepz/.dotfiles\").nixosConfigurations.default.options.home-manager.users.type.getSubOptions []";
                };
              };
            };
          };
        };
      };
    };
  };
}

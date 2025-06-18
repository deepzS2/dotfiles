{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.layout.theme;
in {
  options = {
    layout.theme.enable = lib.mkEnableOption "Enable Kanagawa theming";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      # polarity = "dark";
      # image = ../../../config/theme/wallpapers/dark_souls.jpg;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";

      targets = {
        waybar.addCss = false;
        tmux.enable = false;
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrains Mono Nerd Font";
        };

        sizes = {
          terminal = 11;
          desktop = 10;
          applications = 11;
        };
      };
    };

    gtk = {
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };
    };
  };
}

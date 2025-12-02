{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) assets;
in {
  flake.modules.homeManager.theme = {pkgs, ...}: {
    home.packages = [
      inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.swww
    ];

    home.file.".config/matugen" = {
      source = "${assets.path}/matugen";
      recursive = true;
    };

    stylix = {
      enable = true;
      image = "${assets.media}/wallpapers/yakuza.jpg";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
      targets = {
        niri.enable = true;
        ghostty.enable = false;
        waybar.addCss = false;
        tmux.enable = false;
        vesktop.enable = false;
        vencord.enable = false;
        zen-browser.enable = false;
      };
      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
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

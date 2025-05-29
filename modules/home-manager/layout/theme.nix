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
    home.packages = [
      pkgs.kanagawa-gtk-theme
    ];

    home.sessionVariables.GTK_THEME = "Kanagawa-Dark";

    gtk = {
      enable = true;
      theme = {
        name = "Kanagawa-Dark";
        package = pkgs.kanagawa-gtk-theme;
      };
      iconTheme = {
        name = "Kanagawa-Dark";
        package = pkgs.kanagawa-gtk-theme;
      };
    };
  };
}

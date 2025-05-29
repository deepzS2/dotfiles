{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.layout.wallpaper;
in {
  options = {
    layout.wallpaper.enable = lib.mkEnableOption "Enable SWWW with Pywal theming";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.pywal
      pkgs.imagemagick
      pkgs.swww
    ];

    services.swww.enable = true;

    home.file.".config/wal/templates" = {
      source = ../../../config/wal;
      recursive = true;
    };
  };
}

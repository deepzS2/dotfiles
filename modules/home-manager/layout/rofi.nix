{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.layout.rofi;
in {
  options = {
    layout.rofi.enable = lib.mkEnableOption "Rofi (Wayland support)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.rofi-wayland
    ];

    home.file.".config/rofi" = {
      source = ../../../config/rofi;
      recursive = true;
    };
  };
}

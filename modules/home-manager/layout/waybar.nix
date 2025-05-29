{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.layout.waybar;
in {
  options = {
    layout.waybar.enable = lib.mkEnableOption "Waybar";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      # Network Manager GUI
      pkgs.networkmanagerapplet

      # Audio sources GUI
      pkgs.pavucontrol
    ];

    programs.waybar.enable = true;

    # Bluetooth Manager GUI
    services.blueman-applet.enable = true;

    home.file.".config/waybar" = {
      source = ../../../config/waybar;
      recursive = true;
    };
  };
}

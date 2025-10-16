# Waybar status bar configuration module for Home Manager
# Exported as flake.modules.homeManager.waybar
{
  flake.modules.homeManager.waybar = 
{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.layout.waybar;
  waybarUserConfigDir = "${config.xdg.configHome}/waybar"; # Target directory for Waybar config
  waybarConfigJson = ../../../config/waybar/config.jsonc;
in {
  options = {
    layout.waybar = {
      enable = lib.mkEnableOption "Waybar";
      debug = lib.mkEnableOption "Enable debug mode (symlinking files instead of copying to store, and using @import for CSS)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      # Network Manager GUI
      pkgs.networkmanagerapplet

      # Audio sources GUI
      pkgs.pavucontrol
    ];

    # Bluetooth Manager GUI
    services.blueman-applet.enable = true;

    programs.waybar = {
      enable = true;
      style = lib.mkAfter (
        if cfg.debug
        then ''
          @import "${waybarUserConfigDir}/style.css";
        ''
        else builtins.readFile ../../../config/waybar/style.css
      );
    };

    # Config
    home.file."${waybarUserConfigDir}/config.jsonc" = {
      source =
        if cfg.debug
        then config.lib.file.mkOutOfStoreSymlink waybarConfigJson
        else waybarConfigJson;
    };
  };
}
;
}

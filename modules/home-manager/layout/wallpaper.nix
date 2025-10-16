# Wallpaper management configuration module for Home Manager
# Exported as flake.modules.homeManager.wallpaper
{
  flake.modules.homeManager.wallpaper = 
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
    services.swww.enable = true;
  };
}
;
}

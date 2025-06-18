{pkgs, config, lib, ...}: let
  cfg = config.layout.scripts;
  mkScriptPkg = scriptFile: import scriptFile {inherit pkgs;};
in {
  options = {
    layout.scripts.enable = lib.mkEnableOption "Enable custom scripts for my layout";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (mkScriptPkg ./clipboard.nix)
      (mkScriptPkg ./notification.nix)
      (mkScriptPkg ./powermenu.nix)
      (mkScriptPkg ./startup.nix)
      (mkScriptPkg ./wallpaper_cache.nix)
      (mkScriptPkg ./wallpaper_load.nix)
      (mkScriptPkg ./wallpaper_select.nix)
    ];

    home.file.".theme/sounds" = {
      source = ../../../../config/theme/sounds;
      recursive = true;
    };

    home.file.".theme/wallpapers" = {
      source = ../../../../config/theme/wallpapers;
      recursive = true;
    };
  };
}

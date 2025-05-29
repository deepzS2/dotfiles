{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.layout.hyprland;
in {
  options = {
    layout.hyprland.enable = lib.mkEnableOption "Hyprland Window Manager";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.wl-clipboard
      pkgs.cliphist
      pkgs.hyprshot
    ];

    services.hypridle.enable = true;
    programs.hyprlock.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      extraConfig = builtins.readFile ../../../config/hypr/hyprland.conf;
    };

    home.file.".config/hypr" = {
      source = ../../../config/hypr;
      recursive = true;
    };
  };
}

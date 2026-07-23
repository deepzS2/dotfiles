{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.nixos.hyprland = {
    config,
    lib,
    ...
  }: let
    inherit (config) window-manager;
  in {
    programs.hyprland = lib.mkIf (window-manager == "hyprland") {
      enable = true;
      withUWSM = true; # recommended for most users
      xwayland.enable = true; # Xwayland can be disabled.
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
  };

  flake.modules.hjem.hyprland = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config) window-manager monitors;
  in {
    config = lib.mkIf (window-manager == "hyprland") {
      packages = [
        pkgs.hyprshot
        pkgs.hyprcursor
        pkgs.hyprpicker
      ];

      xdg.config.files."hypr/hyprland.conf".source = "${directories.config}/hyprland.conf";

      xdg.config.files."hypr/monitors.conf".text = lib.concatStringsSep "\n" (
        map (
          monitor: "monitor=${monitor.name},${toString monitor.width}x${toString monitor.height}@${toString monitor.refresh-rate},${
            if monitor.primary
            then "auto"
            else "${toString monitor.x}x${toString monitor.y}"
          },${toString monitor.scale}"
        )
        monitors
      );

      xdg.config.files."hypr/plugins.conf".text = lib.concatStringsSep "\n" [
        "hyprctl plugin load ${pkgs.hyprshot}/lib/libhyprshot.so"
        "hyprctl plugin load ${pkgs.hyprcursor}/lib/libhyprcursor.so"
        "hyprctl plugin load ${pkgs.hyprpicker}/lib/libhyprpicker.so"
      ];
    };
  };
}

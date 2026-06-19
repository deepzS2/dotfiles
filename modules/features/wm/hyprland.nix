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
    # Enables Hyprland
    programs.hyprland = lib.mkIf (window-manager == "hyprland") {
      enable = true;
      withUWSM = true; # recommended for most users
      xwayland.enable = true; # Xwayland can be disabled.
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
  };

  flake.modules.homeManager.hyprland = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config) window-manager monitors;
  in {
    config = lib.mkIf (window-manager == "hyprland") {
      home = {
        packages = [
          pkgs.hyprshot
          pkgs.hyprcursor
          pkgs.hyprpicker
        ];

        pointerCursor.hyprcursor.enable = true;

        file.".config/hypr/hyprland.conf".source = "${directories.config}/hyprland.conf";

        file.".config/hypr/monitors.conf".text = lib.concatStringsSep "\n" (
          map (
            monitor: "monitor=${monitor.name},${toString monitor.width}x${toString monitor.height}@${toString monitor.refresh-rate},${
              if monitor.primary
              then "auto"
              else "${toString monitor.x}x${toString monitor.y}"
            },${toString monitor.scale}"
          )
          monitors
        );

        file.".config/hypr/plugins.conf".text = lib.concatStringsSep "\n" [
          "hyprctl plugin load ${pkgs.hyprshot}/lib/libhyprshot.so"
          "hyprctl plugin load ${pkgs.hyprcursor}/lib/libhyprcursor.so"
          "hyprctl plugin load ${pkgs.hyprpicker}/lib/libhyprpicker.so"
        ];
      };

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
      };
    };
  };
}

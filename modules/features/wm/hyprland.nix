{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.nixos.hyprland = {
    config,
    lib,
    ...
  }: let
    inherit (config.settings) wm;
  in {
    # Enables Hyprland
    programs.hyprland = lib.mkIf (wm == "hyprland") {
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
    inherit (config.settings) wm monitors;
  in {
    config = lib.mkIf (wm == "hyprland") {
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
        enable = wm == "hyprland";
        xwayland.enable = true;
      };
    };
  };
}

{
  inputs,
  self,
  ...
}: let
  inherit (self) directories;
in {
  flake.modules.nixos.mango = {
    lib,
    config,
    ...
  }: let
    inherit (config.settings) wm;
  in {
    imports = [
      inputs.mangowm.nixosModules.mango
    ];

    config = lib.mkIf (wm == "mango") {
      programs.mango = {
        enable = true;
        addLoginEntry = true;
      };

      programs.dconf.enable = true;

      environment.sessionVariables = {
        GTK_IM_MODULE = "ibus";
        QT_IM_MODULE = "ibus";
        XMODIFIERS = "@im=ibus";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_WAYLAND_FORCE_DPI = "140";
        NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
      };
    };
  };

  flake.modules.homeManager.mango = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.settings) wm monitors;

    monitorsConf = lib.concatStringsSep "\n" (map (monitor: ''
        monitorrule=name:${monitor.name},width:${toString monitor.width},height:${toString monitor.height},refresh:${toString monitor.refresh-rate},scale:${toString monitor.scale},x:${toString monitor.x},y:${toString monitor.y}
      '')
      monitors);
  in {
    config = lib.mkIf (wm == "mango") {
      home = {
        packages = [
          pkgs.xdg-desktop-portal
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-wlr
          pkgs.xrdb
          pkgs.xwayland-satellite
          pkgs.ibus
        ];

        file = {
          ".config/mango/config.conf".source = "${directories.config}/mango.conf";
          ".config/mango/monitors.conf".text = monitorsConf;
        };
      };
    };
  };
}

{
  inputs,
  self,
  ...
}: let
  inherit (self) directories;
in {
  flake.modules.nixos.niri = {
    pkgs,
    lib,
    config,
    ...
  }: let
    inherit (config) window-manager;
  in {
    config = lib.mkIf (window-manager == "niri") {
      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };

      nixpkgs.overlays = [inputs.niri.overlays.niri];

      environment.sessionVariables = {
        GTK_IM_MODULE = "ibus";
        QT_IM_MODULE = "ibus";
        XMODIFIERS = "@im=ibus";
        NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
      };
    };
  };

  flake.modules.hjem.niri = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config) window-manager monitors;

    monitorsKdl = lib.concatStringsSep "\n" (map (monitor: ''
        output "${monitor.name}" {
            scale ${toString monitor.scale}
            mode "${toString monitor.width}x${toString monitor.height}@${toString monitor.refresh-rate}"
            position x=${toString monitor.x} y=${toString monitor.y}
        }
      '')
      monitors);
  in {
    config = lib.mkIf (window-manager == "niri") {
      packages = [
        inputs.niri-scratchpad.packages.${pkgs.stdenv.hostPlatform.system}.default
        pkgs.xdg-desktop-portal-gnome
        pkgs.xwayland-satellite
        pkgs.ibus
      ];

      xdg.config.files."niri/config.kdl".source = "${directories.config}/niri.kdl";
      xdg.config.files."niri/monitors.kdl".text = monitorsKdl;

      systemd.services.xwayland-satellite = {
        unitConfig = {
          Description = "Xwayland outside Wayland";
          BindsTo = "graphical-session.target";
          After = ["graphical-session.target"];
        };
        serviceConfig = {
          Type = "notify";
          NotifyAccess = "all";
          ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
          StandardOutput = "journal";
          Restart = "on-failure";
        };
      };
    };
  };
}

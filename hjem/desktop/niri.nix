{
  config,
  lib,
  pkgs,
  self,
  inputs,
  ...
}: let
  inherit (config) monitors;

  monitorsKdl = lib.concatStringsSep "\n" (map (monitor: ''
      output "${monitor.name}" {
          scale ${toString monitor.scale}
          mode "${toString monitor.width}x${toString monitor.height}@${toString monitor.refresh-rate}"
          position x=${toString monitor.x} y=${toString monitor.y}
      }
    '')
    monitors);
in {
  packages = [
    inputs.niri-scratchpad.packages.${pkgs.stdenv.hostPlatform.system}.niri-scratchpad
    pkgs.xwayland-satellite
    pkgs.ibus
  ];

  xdg.config.files."niri/config.kdl".source = "${self}/config/niri.kdl";
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
}

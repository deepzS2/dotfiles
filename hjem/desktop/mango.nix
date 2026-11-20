{
  lib,
  config,
  pkgs,
  self,
  ...
}: let
  inherit (config) monitors;

  monitorsConf = lib.concatStringsSep "\n" (map (monitor: ''
      monitor_rule=name:${monitor.name},width:${toString monitor.width},height:${toString monitor.height},refresh:${toString monitor.refresh-rate},scale:${toString monitor.scale},x:${toString monitor.x},y:${toString monitor.y}
    '')
    monitors);
in {
  packages = [
    pkgs.xrdb
    pkgs.xwayland-satellite
    pkgs.ibus
  ];

  xdg.config.files."mango/config.conf".source = "${self}/config/mango.conf";
  xdg.config.files."mango/monitors.conf".text = monitorsConf;

  systemd.targets.mango-session = {
    unitConfig = {
      Description = "mango compositor session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };
}

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
    inherit (config.settings) wm;
  in {
    config = lib.mkIf (wm == "niri") {
      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };

      environment.sessionVariables = {
        GTK_IM_MODULE = "ibus";
        QT_IM_MODULE = "ibus";
        XMODIFIERS = "@im=ibus";
        NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
      };
    };
  };

  flake.modules.homeManager.niri = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.settings) wm monitors;

    monitorsKdl = lib.concatStringsSep "\n" (map (monitor: ''
        output "${monitor.name}" {
            scale ${toString monitor.scale}
            mode "${toString monitor.width}x${toString monitor.height}@${toString monitor.refresh-rate}"
            position x=${toString monitor.x} y=${toString monitor.y}
        }
      '')
      monitors);
  in {
    config = lib.mkIf (wm == "niri") {
      home = {
        packages = [
          inputs.niri-scratchpad.packages.${pkgs.stdenv.hostPlatform.system}.default
          pkgs.xdg-desktop-portal-gnome
          pkgs.xwayland-satellite
          pkgs.ibus
        ];

        file = {
          ".config/niri/config.kdl".source = "${directories.config}/niri.kdl";
          ".config/niri/monitors.kdl".text = monitorsKdl;
        };
      };

      systemd.user.services.xwayland-satellite = {
        Unit = {
          Description = "Xwayland outside Wayland";
          BindsTo = "graphical-session.target";
          After = "graphical-session.target";
        };
        Service = {
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

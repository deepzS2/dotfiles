{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config) window-manager;

  cfg = config.idle;

  niriCmds = {
    on = "niri msg action power-on-monitors";
    off = "niri msg action power-off-monitors";
  };
  mangoCmds = {
    on = "mmsg dispatch enable_monitor";
    off = "mmsg dispatch disable_monitor";
  };

  commands =
    if window-manager == "mango"
    then mangoCmds
    else niriCmds;

  mkBlock = name: attrs: ''
    ${name} {
      ${lib.concatStringsSep "\n  " (lib.mapAttrsToList (k: v: "${k} = ${toString v}") attrs)}
    }
  '';
in {
  options.idle = {
    lock = lib.mkOption {
      type = lib.types.int;
      description = "Time in minutes to lock screen.";
      example = 300;
    };

    dpms = lib.mkOption {
      type = lib.types.int;
      description = "Time in minutes to shutdown monitors.";
      example = 330;
    };

    suspend = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      description = "Time in minutes to suspend.";
      example = 1800;
    };
  };

  config = {
    packages = [pkgs.hypridle pkgs.brightnessctl];

    xdg.config.files."hypr/hypridle.conf".text = lib.concatStringsSep "\n\n" (lib.filter (s: s != "") [
      (mkBlock "general" {
        lock_cmd = "sheez ipc call lockScreen toggle";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = commands.on;
      })

      (mkBlock "listener" {
        timeout = 150;
        on-timeout = "brightnessctl -s set 10";
        on-resume = "brightnessctl -r";
      })

      (mkBlock "listener" {
        timeout = 150;
        on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
        on-resume = "brightnessctl -rd rgb:kbd_backlight";
      })

      (mkBlock "listener" {
        timeout = cfg.lock;
        on-timeout = "loginctl lock-session";
      })

      (mkBlock "listener" {
        timeout = cfg.dpms;
        on-timeout = commands.off;
        on-resume = "${commands.on} && brightnessctl -r";
      })

      (lib.optionalString (cfg.suspend != null)
        (mkBlock "listener" {
          timeout = cfg.suspend;
          on-timeout = "systemctl suspend";
        }))
    ]);

    systemd.services.hypridle = {
      wantedBy = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "hypridle";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.hypridle}";
        Restart = "always";
        RestartSec = "10";
      };
      restartTriggers = [config.xdg.config.files."hypr/hypridle.conf".source];
    };
  };
}

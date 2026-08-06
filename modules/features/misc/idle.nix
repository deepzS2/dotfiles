{
  flake.modules.hjem.idle = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (config) window-manager;

    niriCmds = {
      on = "niri msg action power-on-monitors";
      off = "niri msg action power-off-monitors";
    };
    hyprCmds = {
      on = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
      off = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'";
    };
    mangoCmds = {
      on = "mmsg dispatch enable_monitor";
      off = "mmsg dispatch disable_monitor";
    };

    commands =
      if window-manager == "mango"
      then mangoCmds
      else if window-manager == "niri"
      then niriCmds
      else hyprCmds;

    idleConf = pkgs.writeText "hypridle.conf" ''
      general {
        lock_cmd = sheez ipc call lockScreen toggle
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = ${commands.on}
      }

      listener {
        timeout = 150
        on-timeout = brightnessctl -s set 10
        on-resume = brightnessctl -r
      }

      listener {
        timeout = 150
        on-timeout = brightnessctl -sd rgb:kbd_backlight set 0
        on-resume = brightnessctl -rd rgb:kbd_backlight
      }

      listener {
        timeout = 300
        on-timeout = loginctl lock-session
      }

      listener {
        timeout = 330
        on-timeout = ${commands.off}
        on-resume = ${commands.on} && brightnessctl -r
      }

      listener {
        timeout = 1800
        on-timeout = systemctl suspend
      }
    '';
  in {
    config = {
      packages = [pkgs.hypridle pkgs.brightnessctl];

      xdg.config.files."hypr/hypridle.conf".source = idleConf;

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
        restartTriggers = [idleConf];
      };
    };
  };
}

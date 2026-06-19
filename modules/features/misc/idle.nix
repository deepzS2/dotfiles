{
  flake.modules.homeManager.idle = {
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
  in {
    # home.packages = [pkgs.brightnessctl];

    systemd.user.services.hypridle = let
      systemdTarget = config.wayland.systemd.target;
    in {
      Install = {
        WantedBy = [systemdTarget];
      };

      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "hypridle";
        After = [systemdTarget];
        PartOf = [systemdTarget];
        X-Restart-Triggers = [
          "${config.home.file.".config/hypr/hypridle.conf".source}"
        ];
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.hypridle}";
        Restart = "always";
        RestartSec = "10";
      };
    };

    home.file.".config/hypr/hypridle.conf".text = lib.hm.generators.toHyprconf {
      attrs = {
        general = {
          lock_cmd = "sheez ipc call lockScreen toggle"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = commands.on; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 150; # 2.5min.
            on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "brightnessctl -r"; # monitor backlight restore.
          }
          # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
          {
            timeout = 150; # 2.5min.
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
            on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
          }
          {
            timeout = 300; # 5min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }
          {
            timeout = 330; # 5.5min
            on-timeout = "${commands.off}"; # screen off when timeout has passed
            on-resume = "${commands.on} && brightnessctl -r"; # screen on when activity is detected after timeout has fired.
          }
          {
            timeout = 1800; # 30min
            on-timeout = "systemctl suspend"; # suspend pc
          }
        ];
      };
      importantPrefixes = ["$"];
    };
  };
}

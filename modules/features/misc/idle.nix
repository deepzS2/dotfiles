{
  flake.modules.homeManager.idle = {
    config,
    pkgs,
    ...
  }: let
    inherit (config) window-manager;

    dpmsOnCmd =
      if window-manager == "niri"
      then "niri msg action power-on-monitors"
      else "hyprctl dispatch dpms on";

    dpmsOffCmd =
      if window-manager == "niri"
      then "niri msg action power-off-monitors"
      else "hyprctl dispatch dpms off";
  in {
    home.packages = [pkgs.brightnessctl];

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "sheez ipc call lockScreen toggle"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = dpmsOnCmd; # to avoid having to press a key twice to turn on the display.
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
            on-timeout = "${dpmsOffCmd}"; # screen off when timeout has passed
            on-resume = "${dpmsOnCmd} && brightnessctl -r"; # screen on when activity is detected after timeout has fired.
          }
          {
            timeout = 1800; # 30min
            on-timeout = "systemctl suspend"; # suspend pc
          }
        ];
      };
    };
  };
}

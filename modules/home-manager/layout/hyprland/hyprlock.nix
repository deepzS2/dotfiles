# Hyprlock screen locker configuration module for Home Manager
# Exported as flake.modules.homeManager.hyprlock
{
  flake.modules.homeManager.hyprlock = {
    config,
    ...
  }: let
    inherit (config.lib.stylix) colors;
    clock_color = colors.base0E;
  in {
    programs.hyprlock = {
      enable = true;
      settings = {
        background = {
          monitor = "";
          blur_passes = 2;
          contrast = 1;
          brightness = 0.9;
          vibrancy = 1;
          vibrancy_darkness = 0;
        };

        general = {
          no_fade_in = false;
          no_fade_out = false;
          grace = 0;
          disable_loading_bar = false;
        };

        "input-field" = {
          monitor = "";
          size = "300, 50";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          dots_rounding = -1;
          fade_on_empty = false;
          fade_timeout = 2000;
          placeholder_text = ''<i> <span>  Enter Password...</span> </i>'';
          hide_input = false;
          rounding = -1;
          fail_text = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
          fail_transition = 300;
          capslock_color = "rgb(${colors.base04})";
          numlock_color = "rgb(${colors.base04})";
          bothlock_color = "rgb(${colors.base04})";
          invert_numlock = false;
          swap_font_color = "rgb(${colors.base03})";
          position = "-40, 40";
          halign = "right";
          valign = "bottom";
        };

        label = [
          {
            # time (hour)
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +'%I')"'';
            color = "rgb(${clock_color})";
            font_size = 200;
            font_family = "Montserrat Italic Bold";
            position = "-50, 200";
            halign = "center";
            valign = "center";
            shadow_passes = 5;
            shadow_size = 10;
          }
          {
            # time (minute)
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +'%M')"'';
            color = "rgb(${clock_color})";
            font_size = 200;
            font_family = "Montserrat Italic Bold";
            position = "50, -10";
            halign = "center";
            valign = "center";
            shadow_passes = 5;
            shadow_size = 10;
          }
          {
            # date
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +'%d %B, %Y')"'';
            color = "rgb(${clock_color})";
            font_size = 25;
            font_family = "Pacifico Regular";
            position = "0, -150";
            halign = "center";
            valign = "center";
            shadow_passes = 5;
            shadow_size = 10;
          }
        ];
      };
    };
  };
}

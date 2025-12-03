{
  flake.modules.homeManager.hyprlock = {
    programs.hyprlock = {
      enable = true;
      settings = {
        source = "colors.conf";

        background = {
          path = "$image";
          monitor = "";
          blur_passes = 2;
          contrast = 1;
          brightness = 0.9;
          vibrancy = 1;
          vibrancy_darkness = 0;
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
          capslock_color = "$primary";
          numlock_color = "$primary";
          bothlock_color = "$primary";
          invert_numlock = false;
          swap_font_color = "$on_surface";
          position = "-40, 40";
          halign = "right";
          valign = "bottom";
        };

        label = [
          {
            # time (hour)
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +'%I')"'';
            color = "$secondary";
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
            color = "$secondary";
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
            color = "$secondary";
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

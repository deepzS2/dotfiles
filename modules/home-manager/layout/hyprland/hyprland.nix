{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.layout.hyprland;
in {
  options = {
    layout.hyprland.enable = lib.mkEnableOption "Hyprland Window Manager";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.wl-clipboard
      pkgs.cliphist
      pkgs.hyprshot
      pkgs.hyprcursor
      pkgs.hyprpicker
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      settings = {
        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor = [",1920x1080@144,auto,1"];

        ###################
        ### MY PROGRAMS ###
        ###################
        "$terminal" = "${pkgs.ghostty}/bin/ghostty";
        "$menu" = "rofi -show drun -theme ~/.config/rofi/launcher.rasi";
        "$fileManager" = "${pkgs.nautilus}/bin/nautilus";
        "$browser" = "zen";
        "$webapp" = "$browser --new-tab";

        #################
        ### AUTOSTART ###
        #################
        exec-once = [
          "${pkgs.swww}/bin/swww-daemon"
          "${pkgs.wl-clipboard}/bin/wl-paste -t text --watch cliphist store"
          "${pkgs.wl-clipboard}/bin/wl-paste -t image --watch cliphist store"
          "${pkgs.waybar}/bin/waybar"
          "hyprctl setcursor Bibata-Modern-Classic 24"
          "initialize_setup"
        ];

        #############################
        ### ENVIRONMENT VARIABLES ###
        #############################
        env = [
          "HYPRCURSOR_THEME,Bibata-Modern-Classic"
          "HYPRCURSOR_SIZE,24"
        ];

        #####################
        ### LOOK AND FEEL ###
        #####################

        # Refer to https://wiki.hyprland.org/Configuring/Variables/

        # https://wiki.hyprland.org/Configuring/Variables/#general
        general = {
          gaps_in = 5;
          gaps_out = 20;

          border_size = 2;

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false;

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;

          layout = "dwindle";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#decoration
        decoration = {
          rounding = 10;
          rounding_power = 2;

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            # color = "rgba(1a1a1aee)";
          };

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur = {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.1696;
          };
        };

        # https://wiki.hyprland.org/Configuring/Variables/#animations
        animations = {
          enabled = true;

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];

          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 1, 1.94, almostLinear, fade"
            "workspacesIn, 1, 1.21, almostLinear, fade"
            "workspacesOut, 1, 1.94, almostLinear, fade"
          ];
        };

        # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
        # "Smart gaps" / "No gaps when only"
        # uncomment all if you wish to use that.
        # workspace = w[tv1], gapsout:0, gapsin:0
        # workspace = f[1], gapsout:0, gapsin:0
        # windowrule = bordersize 0, floating:0, onworkspace:w[tv1]
        # windowrule = rounding 0, floating:0, onworkspace:w[tv1]
        # windowrule = bordersize 0, floating:0, onworkspace:f[1]
        # windowrule = rounding 0, floating:0, onworkspace:f[1]

        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        dwindle = {
          pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below;;
          preserve_split = true; # You probably want this
        };

        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        master = {
          new_status = "master";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#misc
        misc = {
          force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
        };

        #############
        ### INPUT ###
        #############

        # https://wiki.hyprland.org/Configuring/Variables/#input
        input = {
          kb_layout = "br";
          kb_model = "abnt2";
          numlock_by_default = true;
          follow_mouse = 1;
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          touchpad.natural_scroll = false;
        };

        # https://wiki.hyprland.org/Configuring/Variables/#gestures
        gestures = {
          workspace_swipe = false;
        };

        # Example per-device config
        # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
        device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };

        ###################
        ### KEYBINDINGS ###
        ###################

        # See https://wiki.hyprland.org/Configuring/Keywords/

        # Keybindings
        "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier
        bind = [
          "$mainMod, return, exec, $terminal"
          "$mainMod, F, exec, $fileManager"
          "$mainMod, B, exec, $browser"
          "$mainMod, N, exec, $terminal -e nvim"
          "$mainMod, T, exec, $terminal -e btop"
          "$mainMod, D, exec, $terminal -e lazydocker"
          "$mainMod, space, exec, $menu"

          "$mainMod SHIFT, D, exec, vesktop" # Launch Vesktop (Discord)
          "$mainMod SHIFT, L, exec, hyprlock" # Toggle screen lock
          "$mainMod SHIFT, V, exec, cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy" # Clipboard history
          "$mainMod SHIFT, G, exec, $webapp=\"https://web.whatsapp.com/\"" # Launch whatsapp in browser

          "$mainMod, W, killactive,"
          "$mainMod SHIFT, F, fullscreen"
          "$mainMod, V, togglefloating,"
          "$mainMod, P, pseudo," # dwindle
          "$mainMod, J, togglesplit," # dwindle
          "$mainMod, M, exit,"

          ", PRINT, exec, hyprshot -m region" # Screenshot a region
          "SHIFT, PRINT, exec, hyprshot -m window" # Screenshot a window
          "CTRL, PRINT, exec, hyprshot -m output" # Screenshot a monitor

          "$mainMod, PRINT, exec, hyprpicker -a" # Color picker
          "$mainMod, ESCAPE, exec, powermenu" # Toggle power menu

          "$mainMod, comma, exec, makoctl dismiss" # Dismiss notification
          "$mainMod SHIFT, comma, exec, makoctl dismiss --all" # Dismiss all notifications
          "$mainMod CTRL, comma, exec, makoctl mode -t do-not-disturb && makoctl mode | grep -q 'do-not-disturb' && notify-send \"Silenced notifications\" || notify-send \"Enabled notifications\"" # Toggle "Do Not Disturb" mode

          "$mainMod, h, movefocus, l"
          "$mainMod, j, movefocus, d"
          "$mainMod, k, movefocus, u"
          "$mainMod, l, movefocus, r"

          "$mainMod SHIFT, h, swapwindow, l"
          "$mainMod SHIFT, j, swapwindow, d"
          "$mainMod SHIFT, k, swapwindow, u"
          "$mainMod SHIFT, l, swapwindow, r"

          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          "$mainMod, minus, resizeactive, -100 0"
          "$mainMod, equal, resizeactive, 100 0"
          "$mainMod SHIFT, minus, resizeactive, 0 -100"
          "$mainMod SHIFT, equal, resizeactive, 0 100"
        ];
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];
        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        ##############################
        ### WINDOWS AND WORKSPACES ###
        ##############################

        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
        # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

        # Example windowrule
        # windowrule = float,class:^(kitty)$,title:^(kitty)$

        # Ignore maximize requests from apps. You'll probably like this.
        windowrule = [
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        ];
        windowrulev2 = [
          "float, class:^(pavucontrol|org.pulseaudio.pavucontrol)$"
          "move 70% 5%, class:^(pavucontrol|org.pulseaudio.pavucontrol)$"
          "float, class:^([Tt]hunar)$"
          "float, class:([Tt]hunar), title:(Confirm to replace files)"
          "center, class:([Tt]hunar), title:(File Operation Progress)"
          "center, class:([Tt]hunar), title:(Confirm to replace files)"
          "float, class:^(.blueman-manager-wrapped)$"
          "center, class:^(.blueman-manager-wrapped)$"
          "size 50% 50%, class:^(.blueman-manager-wrapped)$"
          "float, class:^(nm-connection-editor)$"
          "center, class:^(nm-connection-editor)$"
          "size 50% 50%, class:^(nm-connection-editor)$"
          "float, class:^(com.obsproject.Studio)$"
          "float, class:^(ghostty)$,title:(yazi)"
          "float, class:^(kitty)$,title:(update)"
          "float, tag:file-manager*, title:(File Operation Progress)"
          "float, class:^([Gg]nome-disks)$"
          "workspace 1, class:^(ghostty)$"
          "workspace 2, class:^(zen-browser)$"
          "workspace 3, class:^(com.obsproject.Studio)$"
        ];
        layerrule = [
          "blur,notifications"
          "blur,rofi"
          "ignorezero,rofi"
          "ignorezero,notifications"
          "blur,logout_dialog"
        ];
      };
    };
  };
}

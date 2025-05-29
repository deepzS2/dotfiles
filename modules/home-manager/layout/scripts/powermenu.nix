{pkgs, ...}:
pkgs.writeShellApplication {
  name = "power_menu";
  runtimeInputs = [
    (import ./notification.nix {inherit pkgs;})
    (import ./uptime.nix {inherit pkgs;})
  ];
  text = ''
    # Current Theme
    ROFI_CONFIG_DIR="$HOME/.config/rofi"
    THEME="$ROFI_CONFIG_DIR/themes/powermenu.rasi"
    CONFIRMATION_THEME="$ROFI_CONFIG_DIR/themes/confirmation.rasi"

    # CMDs
    uptime="$(awk '{printf "%d hour, %d minutes\n", $1/3600, ($1%3600)/60}' /proc/uptime)"

    # Options
    shutdown=''
    reboot=''
    lock=''
    suspend=''
    logout='󰍃'
    yes=''
    no=''

    # Rofi CMD
    rofi_cmd() {
      rofi -dmenu \
        -p "Goodbye ''${USER}" \
        -mesg "Uptime: $uptime" \
        -theme "$THEME"
    }

    # Confirmation CMD
    confirm_cmd() {
      rofi -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme "$CONFIRMATION_THEME"
    }

    # Ask for confirmation
    confirm_exit() {
      echo -e "$yes\n$no" | confirm_cmd
    }

    # Pass variables to rofi dmenu
    run_rofi() {
      echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
    }

    # Execute Command
    run_cmd() {
      selected="$(confirm_exit)"
      if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
          get_uptime
          send_notification logout
          systemctl poweroff --now
        elif [[ $1 == '--reboot' ]]; then
          get_uptime
          send_notification logout
          systemctl reboot --now
        elif [[ $1 == '--lock' ]]; then
          hyprlock
        elif [[ $1 == '--logout' ]]; then
          get_uptime
          send_notification logout
          hyprctl dispatch exit 0
        elif [[ $1 == '--suspend' ]]; then
          get_uptime
          send_notification logout
          systemctl suspend
        fi
      else
        exit 0
      fi
    }

    # Actions
    chosen="$(run_rofi)"
    case ''${chosen} in
    "$shutdown")
      run_cmd --shutdown
      ;;
    "$reboot")
      run_cmd --reboot
      ;;
    "$lock")
      if [[ -x '/usr/bin/betterlockscreen' ]]; then
        betterlockscreen -l
      elif [[ -x '/usr/bin/hyprlock' ]]; then
        run_cmd --lock
      elif [[ -x '/usr/bin/swaylock' ]]; then
        swaylock
      fi
      ;;
    "$suspend")
      run_cmd --suspend
      ;;
    "$logout")
      run_cmd --logout
      ;;
    esac
  '';
}

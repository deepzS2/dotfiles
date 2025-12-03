# Power menu script for Home Manager
# Exported as flake.modules.homeManager.script-powermenu
{config, ...}: let
  inherit (config.flake.settings) window-manager;
in {
  flake.modules.homeManager.scripts = {
    config,
    pkgs,
    ...
  }: {
    home.packages = [
      (
        pkgs.writeShellApplication {
          name = "powermenu";
          runtimeInputs = [
            pkgs.procps
          ];
          text = ''
            # Current Theme
            THEME="$HOME/.config/rofi/powermenu.rasi"
            CONFIRM_THEME="$HOME/.config/rofi/powermenu-confirm.rasi"
            WM=${window-manager}

            # CMDs
            uptime="$(uptime -p | sed -e 's/up //g')"

            # Options
            shutdown='󰐥'
            reboot=''
            lock='󰌾'
            suspend='󰤄'
            logout='󰍃'
            yes='󰗠'
            no='󰅙'

            # Rofi CMD
            rofi_cmd() {
             rofi -dmenu \
                 -p "Goodbye $USER" \
                 -mesg "Uptime: $uptime" \
                 -theme "$THEME"
            }

            # Confirmation CMD
            confirm_cmd() {
              rofi -dmenu \
                -p "Confirmation" \
                -mesg "Are you Sure?" \
                -theme "$CONFIRM_THEME"
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
                  send_notification logout
                  systemctl poweroff --now
                elif [[ $1 == '--reboot' ]]; then
                  send_notification logout
                  systemctl reboot --now
                elif [[ $1 == '--lock' ]]; then
                  hyprlock
                 elif [[ $1 == '--logout' ]]; then
                   send_notification logout

                   if [[ $WM == "hyprland" ]]; then
                     hyprctl dispatch exit 0
                   elif [[ $WM == "niri" ]]; then
                     niri msg action quit
                   else
                     send_notification notify "Unknown window manager, cannot logout..."
                   fi
                elif [[ $1 == '--suspend' ]]; then
                  send_notification logout
                  amixer set Master mute
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
              run_cmd --lock
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
      )
    ];
  };
}

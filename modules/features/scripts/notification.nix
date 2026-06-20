{
  flake.modules.homeManager.scripts = {pkgs, ...}: {
    home.packages = [
      (
        pkgs.writeShellApplication {
          name = "send_notification";
          runtimeInputs = [
            pkgs.pulseaudio
            pkgs.libnotify
          ];
          text = ''
            SOUND_FILE_UPDATE="$HOME/.theme/sounds/update.wav"
            SOUND_FILE_SYSTEM="$HOME/.theme/sounds/system-startup.wav"
            SOUND_FILE_LOGOUT="$HOME/.theme/sounds/poweroff.mp3"

            notify_with_sound() {
              local summary="$1" body="$2" icon="$3"
              local -a args=()

              args+=("$summary")
              [[ -n "$icon" ]] && args+=(-i "$icon")
              [[ -n "$body" ]] && args+=("$body")

              notify-send "''${args[@]}"
              paplay "$SOUND_FILE_UPDATE" &
            }

            usage() {
              echo "Usage: $0 {sys|logout|notify} [summary] [body] [icon]" >&2
            }

            case $1 in
              sys)
                paplay "$SOUND_FILE_SYSTEM" &
                ;;
              logout)
                paplay "$SOUND_FILE_LOGOUT" &
                ;;
              notify)
                if [[ -n "$2" ]]; then
                  notify_with_sound "$2" "$3" "''${4:-}"
                else
                  usage
                  exit 1
                fi
                ;;
              *)
                usage
                exit 1
                ;;
            esac
          '';
        }
      )
    ];
  };
}

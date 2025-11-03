# Notification script for Home Manager
# Exported as flake.modules.homeManager.script-notification
{
  flake.modules.homeManager.scripts = {pkgs, ...}: {
    home.packages = [
      (
        pkgs.writeShellApplication {
          name = "send_notification";
          runtimeInputs = [pkgs.pulseaudio];
          text = ''
            # Path to the sound files
            SOUND_FILE_UPDATE="$HOME/.theme/sounds/update.wav"
            SOUND_FILE_SYSTEM="$HOME/.theme/sounds/system-startup.wav"
            SOUND_FILE_LOGOUT="$HOME/.theme/sounds/poweroff.mp3"

            # Function to send notification and play sound
            notify_with_sound() {
              notify-send "$1"
              paplay "$SOUND_FILE_UPDATE"
            }

            startup_with_sound() {
              paplay "$SOUND_FILE_SYSTEM"
            }

            logout_with_sound() {
              paplay "$SOUND_FILE_LOGOUT"
            }

            case $1 in
            sys)
              startup_with_sound
              ;;
            logout)
              logout_with_sound
              ;;
            notify)
              if [ -n "$2" ]; then
                notify_with_sound "$2"
              else
                echo "Please provide a message for the notification."
              fi
              ;;
            *)
              echo "Usage: $0 {sys|notify} [message]"
              ;;
            esac
          '';
        }
      )
    ];
  };
}

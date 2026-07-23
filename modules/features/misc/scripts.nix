{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.hjem.scripts = {
    pkgs,
    lib,
    ...
  }: {
    config = {
      packages = [
        pkgs.wl-clipboard
        pkgs.wl-clip-persist
        pkgs.cliphist
        pkgs.gnupg
        pkgs.pinentry-qt
        pkgs.grim
        pkgs.slurp
        pkgs.satty
        pkgs.networkmanager
      ];

      xdg.config.files.".gnupg/gpg-agent.conf".text = ''
        pinentry-program ${lib.getExe pkgs.pinentry-qt}
      '';

      xdg.config.files."scripts".source = "${directories.config}/scripts";
    };
  };

  flake.modules.hjem.scripts-extras = {pkgs, ...}: {
    config.packages = [
      # Clipboard manager
      (
        pkgs.writeShellApplication {
          name = "cliphistory";
          runtimeInputs = [pkgs.rofi pkgs.wl-clipboard pkgs.cliphist];
          text = ''
            theme="$HOME/.config/rofi/cliphistory.rasi"

            case $1 in
            c)
                cliphist list | rofi -dmenu -config "$theme" | cliphist decode | wl-copy
                ;;
            w)
                if [ "$(echo -e "Yes\nNo" | rofi -dmenu -theme-str "entry { placeholder: \" Clear Clipboard History?\";}" -config "$theme")" == "Yes" ]; then
                    cliphist wipe
                fi
                ;;
            l)
                cliphist list | wc -l
                ;;
            *)
                echo -e "cliphist.sh [action]"
                echo "c :  cliphist list and copy selected"
                echo "w :  cliphist wipe database"
                echo "l :  show the number of items in the clipboard"
                exit 1
                ;;
            esac
          '';
        }
      )

      # Notification helper
      (
        pkgs.writeShellApplication {
          name = "send_notification";
          runtimeInputs = [pkgs.pulseaudio pkgs.libnotify];
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

      # Password menu
      (
        pkgs.writeShellApplication {
          name = "passmenu";
          runtimeInputs = [pkgs.rofi pkgs.passage pkgs.rage pkgs.pinentry-qt];
          text = ''
            shopt -s nullglob globstar

            prefix="''${PASSAGE_DIR:-$HOME/.passage/store}"
            theme="$HOME/.config/rofi/cliphistory.rasi"
            export PASSAGE_AGE="rage"

            if [[ ! -d "$prefix" ]]; then
              rofi -e "Passage store not found at $prefix"
              exit 1
            fi

            password_files=( "$prefix"/**/*.age )
            password_files=( "''${password_files[@]#"$prefix"/}" )
            password_files=( "''${password_files[@]%.age}" )

            password=$(printf '%s\n' "''${password_files[@]}" | rofi -dmenu -theme-str "entry { placeholder:\" Pick a password\";}" -theme-str "textbox-prompt-colon { str:\"\";}" -config "$theme" "$@")

            [[ -n $password ]] || exit 0

            passage show -c "$password" > /dev/null 2>&1
          '';
        }
      )

      # Screenshot
      (
        pkgs.writeShellApplication {
          name = "screenshot";
          runtimeInputs = [pkgs.grim pkgs.slurp pkgs.satty];
          text = ''
            set -euo pipefail
            mkdir -p "$HOME/Pictures/Screenshots"
            filepath="$HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png"

            case "''${1:-fullscreen}" in
              region)
                g=$(slurp -d); [ -z "$g" ] && exit 1
                grim -g "$g" "$filepath" ;;

              window)
                g=$(mmsg -x | awk '/x / {x=$3} /y / {y=$3} /width / {w=$3} /height / {h=$3} END {print x","y" "w"x"h}')
                [ -z "$g" ] && exit 1
                grim -g "$g" "$filepath" ;;

              freeze)
                p=$(mktemp -u).fifo; mkfifo "$p"
                wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $p" & wp=$!
                read -r < "$p"; grim "$filepath"
                kill "$wp" 2>/dev/null; rm -f "$p" ;;

              freeze-region)
                p=$(mktemp -u).fifo; mkfifo "$p"
                wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $p" & wp=$!
                read -r < "$p"; g=$(slurp -d)
                if [ -z "$g" ]; then kill "$wp" 2>/dev/null; rm -f "$p"; exit 1; fi
                grim -g "$g" "$filepath"
                kill "$wp" 2>/dev/null; rm -f "$p" ;;

              annotate)
                grim "$filepath"; satty --filename "$filepath" --output-filename "$filepath" --actions-on-enter save-to-file --early-exit ;;

              *) grim "$filepath" ;;
            esac
          '';
        }
      )

      # WiFi menu
      (
        pkgs.writeShellApplication {
          name = "wifimenu";
          runtimeInputs = [pkgs.networkmanager pkgs.rofi];
          text = ''
            THEME="$HOME/.config/rofi/wifimenu.rasi"
            PASSWORD_THEME="$HOME/.config/rofi/wifimenu-password.rasi"

            send_notification notify "Getting list of available Wi-Fi networks..."

            wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/   / /g" | sed "/--/d")

            connected=$(nmcli -fields WIFI g)
            if [[ "$connected" =~ "enabled" ]]; then
            	toggle="  Disable Wi-Fi"
            elif [[ "$connected" =~ "disabled" ]]; then
            	toggle="  Enable Wi-Fi"
            fi

            chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -theme "$THEME" -p "Wi-Fi SSID: " )
            read -r chosen_id <<< "''${chosen_network: 3}"

            if [ "$chosen_network" = "" ]; then
            	exit
            elif [ "$chosen_network" = "  Enable Wi-Fi" ]; then
            	nmcli radio wifi on
            elif [ "$chosen_network" = "  Disable Wi-Fi" ]; then
            	nmcli radio wifi off
            else
              	success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
            	saved_connections=$(nmcli -g NAME connection)
            	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
            		nmcli connection up id "$chosen_id" | grep "successfully" && send_notification notify "Connection Established" "$success_message"
            	else
            		if [[ "$chosen_network" =~ " " ]]; then
            			wifi_password=$(rofi -dmenu -p "Password: " -theme "$PASSWORD_THEME")
            		fi
            		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && send_notification notify "Connection Established" "$success_message"
                fi
            fi
          '';
        }
      )

      # Setup initialization
      (
        pkgs.writeShellApplication {
          name = "initialize_setup";

          text = ''
            exec_bg () {
              "$@" >/dev/null 2>&1 &
            }

            send_notification sys

            exec_bg wl-clip-persist --clipboard regular --reconnect-tries 0 >/dev/null 2>&1 &
            exec_bg wl-paste -t image --watch cliphist store
            exec_bg wl-paste -t text --watch cliphist store
            exec_bg hypridle
            exec_bg awww-daemon
            exec_bg sheez

            sleep 1

            if theme-switcher --restore 2>/dev/null; then
              send_notification notify "Theme restored"
            fi
          '';
        }
      )
    ];
  };

  flake.modules.hjem.theme-switcher = {pkgs, ...}: {
    config.packages = [
      (
        pkgs.writeShellApplication {
          name = "theme-switcher";
          runtimeInputs = [
            pkgs.gowall
            pkgs.rofi
            pkgs.coreutils
            self.inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
          text = ''
            WALLPAPER_SOURCE="$HOME/.theme/wallpapers"
            CACHE_DIR="$HOME/.cache/gowall"
            LAST_SELECTION_FILE="$CACHE_DIR/last-selection.json"
            THEME_MENU="$HOME/.config/rofi/theme-switcher.rasi"
            WALLPAPER_MENU="$HOME/.config/rofi/wallpaper-switcher.rasi"

            get_wallpapers() {
              local -n arr="$1"
              local w
              for w in "$WALLPAPER_SOURCE"/*.{png,jpg,jpeg,webp}; do
                [[ -f "$w" ]] || continue
                arr+=("$w")
              done
            }

            is_theme_cached() {
              local theme="$1"
              local theme_cache_dir="$CACHE_DIR/$theme"
              [[ -d "$theme_cache_dir" ]] || return 1

              local -a wallpapers=()
              get_wallpapers wallpapers

              local w basename
              for w in "''${wallpapers[@]}"; do
                basename=$(basename "$w")
                [[ -f "$theme_cache_dir/$basename" ]] || return 1
              done
            }

            convert_wallpapers() {
              local theme="$1"
              local theme_cache_dir="$CACHE_DIR/$theme"

              mkdir -p "$theme_cache_dir"

              local -a wallpapers=()
              get_wallpapers wallpapers

              local to_convert=""
              local w basename
              for w in "''${wallpapers[@]}"; do
                basename=$(basename "$w")
                if [[ ! -f "$theme_cache_dir/$basename" ]]; then
                  if [[ -n "$to_convert" ]]; then
                    to_convert="$to_convert,$w"
                  else
                    to_convert="$w"
                  fi
                fi
              done

              [[ -z "$to_convert" ]] && return 0

              gowall convert --theme "$theme" --batch "$to_convert" --output "$theme_cache_dir"
            }

            apply_theme() {
              local theme="$1"
              local wallpaper="$2"
              local wallpaper_path="$CACHE_DIR/$theme/$wallpaper"

              matugen image "$wallpaper_path" --source-color-index 0

              mkdir -p "$CACHE_DIR"
              printf '%s\n' "$theme" "$wallpaper" > "$LAST_SELECTION_FILE"
              send_notification notify "Theme Switcher" "Theme applied: $theme" "$wallpaper_path"
            }

            ensure_default_theme() {
              local theme
              theme=$(gowall list | head -n1)
              [[ -z "$theme" ]] && return 1

              if ! is_theme_cached "$theme"; then
                convert_wallpapers "$theme"
              fi

              local img
              for img in "$CACHE_DIR/$theme"/*.{png,jpg,jpeg,webp}; do
                [[ -f "$img" ]] || continue
                echo "$theme"
                basename "$img"
                return 0
              done
              return 1
            }

            restore_last_theme() {
              local theme="" wallpaper=""

              if [[ -f "$LAST_SELECTION_FILE" ]]; then
                theme=$(sed -n '1p' "$LAST_SELECTION_FILE")
                wallpaper=$(sed -n '2p' "$LAST_SELECTION_FILE")
              fi

              local wallpaper_path="$CACHE_DIR/$theme/$wallpaper"
              if [[ -n "$theme" && -n "$wallpaper" && -f "$wallpaper_path" ]]; then
                matugen image "$wallpaper_path" --source-color-index 0
                return 0
              fi

              local default_theme default_wallpaper
              { IFS= read -r default_theme && IFS= read -r default_wallpaper; } < <(ensure_default_theme) || return 1
              apply_theme "$default_theme" "$default_wallpaper"
            }

            main() {
              if [[ "''${1:-}" == "--restore" ]]; then
                if restore_last_theme; then
                  exit 0
                else
                  echo "No theme could be applied (no previous selection and no default available)"
                  exit 1
                fi
              fi

              if [[ ! -d "$WALLPAPER_SOURCE" ]]; then
                notify-send "Theme Switcher" "Wallpaper directory not found: $WALLPAPER_SOURCE"
                exit 1
              fi

              local theme
              theme=$(gowall list | rofi -dmenu -i -p "󰏘 Theme" -theme "$THEME_MENU")

              if [[ -z "$theme" ]]; then
                exit 0
              fi

              if ! is_theme_cached "$theme"; then
                notify-send "Theme Switcher" "Converting wallpapers to $theme theme..."
                convert_wallpapers "$theme"
              fi

              local theme_cache_dir="$CACHE_DIR/$theme"
              local wallpaper
              wallpaper=$(
                for img in "$theme_cache_dir"/*.{png,jpg,jpeg,webp}; do
                  [[ -f "$img" ]] || continue
                  local basename
                  basename=$(basename "$img")
                  echo -en "''${basename}\0icon\x1f''${img}\n"
                done | rofi -dmenu -i -p "󰸉 Wallpaper" -mesg "Theme: $theme" -theme "$WALLPAPER_MENU"
              )

              if [[ -z "$wallpaper" ]]; then
                exit 0
              fi

              local wallpaper_path="$theme_cache_dir/$wallpaper"

              apply_theme "$theme" "$wallpaper"
            }

            main "$@"
          '';
        }
      )
    ];
  };

  flake.modules.hjem.youtube = {
    pkgs,
    config,
    ...
  }: let
    musicDir = config.directory + "/music";
  in {
    config.packages = [
      (
        pkgs.writeShellApplication {
          name = "yt";

          runtimeInputs = [pkgs.yt-dlp pkgs.ffmpeg pkgs.coreutils pkgs.gnugrep pkgs.gawk pkgs.util-linux];

          text = ''
            set -euo pipefail

            MUSIC_DIR="${musicDir}"

            print_usage() {
              cat << 'EOF'
            Usage: yt <command> <url>

            Commands:
              song <youtube_music_url>    Download a single song to ~/music/<artist>/<title>.mp3
              playlist <playlist_url>     Download all songs from a playlist to ~/music/<artist>/<title>.mp3

            Options:
              -h, --help                  Show this help message
            EOF
            }

            is_playlist_url() {
              local url="$1"
              if echo "$url" | grep -qE '[?&]list='; then
                return 0
              fi
              return 1
            }

            download_song() {
              local url="$1"
              local output_dir="$2"

              if is_playlist_url "$url"; then
                echo "Error: This URL appears to be a playlist."
                echo "Use 'yt playlist <url>' instead to download all tracks from a playlist."
                exit 1
              fi

              echo "Downloading song..."
              echo "Output directory: $output_dir"
              mkdir -p "$output_dir"

              yt-dlp \
                --quiet \
                --no-warnings \
                --extract-audio \
                --audio-format mp3 \
                --audio-quality 0 \
                --embed-metadata \
                --embed-thumbnail \
                --convert-thumbnails jpg \
                --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
                --output "$output_dir/%(artist,uploader)s/%(title)s.%(ext)s" \
                --no-overwrites \
                "$url"

              echo "Download complete!"
            }

            download_playlist() {
              local url="$1"

              if ! is_playlist_url "$url"; then
                echo "Error: This URL does not appear to be a playlist."
                echo "Use 'yt song <url>' instead to download a single song."
                exit 1
              fi

              echo "Fetching playlist information..."

              local playlist_title
              playlist_title=$(yt-dlp --quiet --no-warnings --print "%(playlist_title)s" "$url" 2>/dev/null || echo "")

              if [ -z "$playlist_title" ] || [ "$playlist_title" = "NA" ]; then
                echo "Error: Could not fetch playlist title."
                exit 1
              fi

              echo "Playlist: $playlist_title"
              mkdir -p "$MUSIC_DIR"

              yt-dlp \
                --quiet \
                --no-warnings \
                --extract-audio \
                --audio-format mp3 \
                --audio-quality 0 \
                --embed-metadata \
                --embed-thumbnail \
                --convert-thumbnails jpg \
                --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
                --output "$MUSIC_DIR/%(artist,uploader)s/%(title)s.%(ext)s" \
                --no-overwrites \
                "$url"

              echo "Playlist download complete!"
              echo "Files saved to: $MUSIC_DIR"
            }

            if [ $# -eq 0 ]; then
              print_usage
              exit 1
            fi

            case "$1" in
              -h|--help)
                print_usage
                exit 0
                ;;
              song)
                if [ $# -lt 2 ]; then
                  echo "Error: Missing URL for song command"
                  print_usage
                  exit 1
                fi
                download_song "$2" "$MUSIC_DIR"
                ;;
              playlist)
                if [ $# -lt 2 ]; then
                  echo "Error: Missing URL for playlist command"
                  print_usage
                  exit 1
                fi
                download_playlist "$2"
                ;;
              *)
                echo "Error: Unknown command '$1'"
                print_usage
                exit 1
                ;;
            esac
          '';
        }
      )
    ];
  };
}

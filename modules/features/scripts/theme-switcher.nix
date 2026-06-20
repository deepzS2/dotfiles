{inputs, ...}: {
  flake.modules.homeManager.scripts = {pkgs, ...}: {
    home.packages = [
      (
        pkgs.writeShellApplication {
          name = "theme-switcher";
          runtimeInputs = [
            pkgs.gowall
            pkgs.rofi
            pkgs.coreutils
            inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
          text = ''
            # Configuration
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

            # Convert all wallpapers to a specific theme
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
                  # Format: name\0icon\x1f/full/path/to/image
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
}

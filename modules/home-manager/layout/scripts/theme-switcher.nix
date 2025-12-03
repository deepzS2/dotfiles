{
  flake.modules.homeManager.scripts = {pkgs, ...}: {
    home.packages = [
      (
        pkgs.writeShellApplication {
          name = "theme-switcher";
          runtimeInputs = [
            pkgs.gowall
            pkgs.rofi
            pkgs.coreutils
          ];
          text = ''
            # Configuration
            WALLPAPER_SOURCE="$HOME/.theme/wallpapers"
            CACHE_DIR="$HOME/.cache/gowall"
            LAST_SELECTION_FILE="$CACHE_DIR/last-selection.json"
            MATUGEN_CONFIG="$HOME/.config/matugen"
            THEME_MENU="$HOME/.config/rofi/theme-switcher.rasi"
            WALLPAPER_MENU="$HOME/.config/rofi/wallpaper-switcher.rasi"

            # Ensure cache directory exists
            mkdir -p "$CACHE_DIR"

            # Check if all wallpapers are already converted for a theme
            is_theme_cached() {
              local theme="$1"
              local theme_cache_dir="$CACHE_DIR/$theme"

              if [[ ! -d "$theme_cache_dir" ]]; then
                return 1
              fi

              local wallpaper
              for wallpaper in "$WALLPAPER_SOURCE"/*.{png,jpg,jpeg,webp}; do
                [[ -f "$wallpaper" ]] || continue
                local basename
                basename=$(basename "$wallpaper")
                if [[ ! -f "$theme_cache_dir/$basename" ]]; then
                  return 1
                fi
              done

              return 0
            }

            # Convert all wallpapers to a specific theme
            convert_wallpapers() {
              local theme="$1"
              local theme_cache_dir="$CACHE_DIR/$theme"

              mkdir -p "$theme_cache_dir"

              # Build comma-separated list of wallpapers that need conversion
              local to_convert=""
              local wallpaper
              for wallpaper in "$WALLPAPER_SOURCE"/*.{png,jpg,jpeg,webp}; do
                [[ -f "$wallpaper" ]] || continue
                local basename
                basename=$(basename "$wallpaper")
                if [[ ! -f "$theme_cache_dir/$basename" ]]; then
                  if [[ -n "$to_convert" ]]; then
                    to_convert="$to_convert,$wallpaper"
                  else
                    to_convert="$wallpaper"
                  fi
                fi
              done

              if [[ -z "$to_convert" ]]; then
                return 0
              fi

              # Convert wallpapers
              gowall convert --theme "$theme" --batch "$to_convert" --output "$theme_cache_dir"
            }

            # Restore last theme (for startup)
            restore_last_theme() {
              if [[ ! -f "$LAST_SELECTION_FILE" ]]; then
                return 1
              fi

              local selection
              selection=$(cat "$LAST_SELECTION_FILE")

              local theme wallpaper
              theme=$(echo "$selection" | sed -n 's/.*"theme": *"\([^"]*\)".*/\1/p')
              wallpaper=$(echo "$selection" | sed -n 's/.*"wallpaper": *"\([^"]*\)".*/\1/p')

              if [[ -z "$theme" ]] || [[ -z "$wallpaper" ]]; then
                return 1
              fi

              local wallpaper_path="$CACHE_DIR/$theme/$wallpaper"

              if [[ ! -f "$wallpaper_path" ]]; then
                return 1
              fi

              swww img --transition-type center "$wallpaper_path"
              cd "$MATUGEN_CONFIG" && matugen image "$wallpaper_path"

              return 0
            }

            # Main function
            main() {
              # Check for restore flag
              if [[ "''${1:-}" == "--restore" ]]; then
                if restore_last_theme; then
                  exit 0
                else
                  echo "No previous theme to restore"
                  exit 1
                fi
              fi

              # Check if wallpaper source exists
              if [[ ! -d "$WALLPAPER_SOURCE" ]]; then
                notify-send "Theme Switcher" "Wallpaper directory not found: $WALLPAPER_SOURCE"
                exit 1
              fi

              # Step 1: Select theme using rofi
              local theme
              theme=$(gowall list | rofi -dmenu -i -p "󰏘 Theme" -theme "$THEME_MENU")

              if [[ -z "$theme" ]]; then
                exit 0
              fi

              # Step 2: Convert wallpapers if needed
              if ! is_theme_cached "$theme"; then
                notify-send "Theme Switcher" "Converting wallpapers to $theme theme..."
                convert_wallpapers "$theme"
              fi

              # Step 3: Select wallpaper with image thumbnails using rofi
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

              # Step 4: Apply wallpaper
              swww img --transition-type center "$wallpaper_path"

              # Step 5: Generate colors with matugen
              cd "$MATUGEN_CONFIG" && matugen image "$wallpaper_path"

              # Step 6: Save selection
              echo "{\"theme\": \"$theme\", \"wallpaper\": \"$wallpaper\"}" > "$LAST_SELECTION_FILE"

              # Step 7: Send notification
              send_notification notify "Theme applied: $theme"
            }

            main "$@"
          '';
        }
      )
    ];
  };
}

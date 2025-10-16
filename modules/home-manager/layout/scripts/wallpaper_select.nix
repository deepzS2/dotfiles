# Wallpaper selection script for Home Manager
# Exported as flake.modules.homeManager.script-wallpaper-select
{
  flake.modules.homeManager.script-wallpaper-select = 
{pkgs, ...}:
pkgs.writeShellApplication {
  name = "select_wallpaper";
  runtimeInputs = [
    pkgs.pywal
    pkgs.swww
    pkgs.rofi
    pkgs.swaynotificationcenter
    (import ./wallpaper_cache.nix {inherit pkgs;})
  ];
  text = ''
    # Define directories and paths
    THEME="$HOME/.config/rofi/themes/wallpaper.rasi"
    WALLPAPERS_DIR="$HOME/.theme/wallpapers"
    CACHE_DIR="$HOME/.cache/wal"

    # Create cache directory if it doesn't exist
    mkdir -p "$CACHE_DIR"

    # Find all wallpapers using mapfile to properly handle filenames with spaces
    mapfile -d $'\0' WALLPAPERS < <(find "$WALLPAPERS_DIR" \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \) -print0)

    # Function to format filename (replace underscores with spaces and capitalize words)
    format_filename() {
      local filename
      local name_without_ext
      local formatted_name

      filename="$(basename "$1")"
      name_without_ext="''${filename%.*}"

      # Replace underscores with spaces and capitalize first letter of each word
      formatted_name=$(echo "$name_without_ext" | tr '_' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

      echo "$formatted_name"
    }

    # Function to generate thumbnail previews for Rofi
    generate_previews() {
      local preview_dir="$CACHE_DIR/rofi_previews"
      mkdir -p "$preview_dir"

      # Generate preview string for Rofi
      preview_str=""
      for i in "''${!WALLPAPERS[@]}"; do
        wallpaper="''${WALLPAPERS[$i]}"
        base_name="$(basename "$wallpaper")"
        preview_file="$preview_dir/$base_name.png"
        formatted_name="$(format_filename "$wallpaper")"

        # Generate thumbnail if it doesn't exist
        if [ ! -f "$preview_file" ]; then
          convert "$wallpaper" -thumbnail 280x280^ -gravity center -extent 280x280 "$preview_file"
        fi

        # Add to preview string - use index as the selectable text
        # Format: "index: formatted_name\0icon\x1fpreview_file\n"
        if [ "$i" -eq $((''${#WALLPAPERS[@]} - 1)) ]; then
          preview_str="''${preview_str}''${i}: ''${formatted_name}\0icon\x1f''${preview_file}"
        else
          preview_str="''${preview_str}''${i}: ''${formatted_name}\0icon\x1f''${preview_file}\n"
        fi
      done

      echo -e "$preview_str"
    }

    # Use Rofi to select wallpaper
    selected_index=$(generate_previews | rofi -dmenu -i -markup-rows \
      -p "Select Wallpaper" \
      -config "$THEME" \
      -format 's' \
      -display-icon-column |
      cut -d':' -f1)

    # If a wallpaper is selected, proceed
    if [ -n "$selected_index" ]; then
      # Get the selected wallpaper path from the array
      selected_wallpaper="''${WALLPAPERS[$selected_index]}"

      notify-send -i "$selected_wallpaper" "Applying Wallpaper" "Setting wallpaper and generating color scheme..."

      # Run pywal to generate color scheme
      wal -i "$selected_wallpaper" -n -s

      # Link the selected wallpaper to current_wallpaper.png
      ln -sf "$selected_wallpaper" "$CACHE_DIR/current_wallpaper.png"

      # Save the wallpaper name to .wallpaper file
      base_name="$(basename "$selected_wallpaper")"
      wall_name="''${base_name%.*}"
      echo "$wall_name" >"$CACHE_DIR/.wallpaper"

      # Use swww to set the wallpaper with transition effects
      FPS=60
      TYPE="random"
      DURATION=1
      BEZIER=".43,1.19,1,.4"
      SWWW_PARAMS=(
        "--transition-fps" "$FPS"
        "--transition-type" "$TYPE"
        "--transition-duration" "$DURATION"
        "--transition-bezier" "$BEZIER"
      )

      swww query
      swww img "$selected_wallpaper" "''${SWWW_PARAMS[@]}"

      # Run wallcache script to generate cached versions
      generate_wallpaper_cache
      killall -SIGUSR2 waybar
      swaync-client -rs

      notify-send -i "$selected_wallpaper" "Wallpaper Applied" "New theme is ready!"
    fi '';
}
;
}

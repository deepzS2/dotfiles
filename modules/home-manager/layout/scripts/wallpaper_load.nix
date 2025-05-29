{pkgs, ...}:
pkgs.writeShellApplication {
  name = "load_wallpaper";
  runtimeInputs = [
    pkgs.pywal
    pkgs.swww
    pkgs.swaynotificationcenter
    (import ./wallpaper_cache.nix {inherit pkgs;})
  ];
  text = ''
    CACHE_DIR="$HOME/.cache/wal"
    WALLPAPERS_DIR="$HOME/.theme/wallpapers"
    WALLPAPER_CACHE="$CACHE_DIR/.wallpaper"

    [[ ! -f "$WALLPAPER_CACHE" ]] && touch "$WALLPAPER_CACHE"

    mapfile -d $'\0' WALLPAPERS < <(find "$WALLPAPERS_DIR" \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \) -print0)
    WALLPAPER_COUNT=''${#WALLPAPERS[@]}

    INDEX=$((RANDOM % WALLPAPER_COUNT))
    wallpaper="''${WALLPAPERS[$INDEX]}"
    echo "Selected wallpaper ($INDEX of $WALLPAPER_COUNT): $wallpaper"

    # Transition config
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

    notify-send -i "''${wallpaper}" "Changing wallpaper" -t 1500
    swww query
    swww img "''${wallpaper}" "''${SWWW_PARAMS[@]}"

    ln -sf "$wallpaper" "$CACHE_DIR/current_wallpaper.png"

    baseName="$(basename "$wallpaper")"
    wallName=''${baseName%.*}
    echo "$wallName" >"$WALLPAPER_CACHE"
    wal -i "$wallpaper" -n -s

    sleep 0.5
    generate_wallpaper_cache
    killall -SIGUSR2 waybar
    swaync-client -rs
  '';
}

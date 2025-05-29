{pkgs, ...}:
pkgs.writeShellApplication {
  name = "initialize_setup";
  runtimeInputs = [
    pkgs.swww
    (import ./notification.nix {inherit pkgs;})
    (import ./wallpaper_cache.nix {inherit pkgs;})
    (import ./wallpaper_load.nix {inherit pkgs;})
  ];
  text = ''
    CURRENT_WALLPAPER="$HOME/.cache/wal/current_wallpaper.png"

    # Transition config
    FPS=60
    TYPE="any"
    DURATION=2
    BEZIER=".43,1.19,1,.4"
    SWWW_PARAMS=(
      "--transition-fps" "$FPS"
      "--transition-type" "$TYPE"
      "--transition-duration" "$DURATION"
      "--transition-bezier" "$BEZIER"
    )

    if [ -f "$CURRENT_WALLPAPER" ]; then
      swww img "''${CURRENT_WALLPAPER}" "''${SWWW_PARAMS[@]}"
    else
      load_wallpaper
    fi

    send_notification sys
    generate_wallpaper_cache
    hyprctl reload
  '';
}

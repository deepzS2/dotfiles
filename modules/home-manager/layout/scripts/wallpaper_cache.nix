{pkgs, ...}:
pkgs.writeShellApplication {
  name = "generate_wallpaper_cache";
  runtimeInputs = [pkgs.imagemagick];
  text = ''
    #!/usr/bin/env bash

    # Set environment variables
    export CACHE_DIR="$HOME/.cache/wal"
    export THUMBS_DIR="''${CACHE_DIR}/thumbs"
    currentWall_name="$(cat "''${CACHE_DIR}/.wallpaper")"

    # Input file
    input_file="''${CACHE_DIR}/current_wallpaper.png"

    mkdir -p "''${THUMBS_DIR}"
    chmod u+w "''${THUMBS_DIR}"

    # Check if the input file exists
    if [ ! -f "''${input_file}" ]; then
      exit 1
    fi

    # Define the fn_wallcache function
    fn_wallcache() {
      local wall_name="''${1}"
      local x_wall="''${2}"

      # Generate square thumbnail
      [ ! -e "''${THUMBS_DIR}/''${wall_name}.sqre" ] &&
        magick "''${x_wall}"[0] -strip -thumbnail 500x500^ -gravity center -extent 500x500 \
          "''${THUMBS_DIR}/''${wall_name}.sqre"

      # Generate blurred image
      [ ! -e "''${THUMBS_DIR}/''${wall_name}.blur" ] &&
        magick "''${x_wall}"[0] -strip -scale 70% -blur 0x10 -resize 100% \
          "''${THUMBS_DIR}/''${wall_name}.blur"

      # Generate quad image
      [ ! -e "''${THUMBS_DIR}/''${wall_name}.quad" ] &&
        magick "''${THUMBS_DIR}/''${wall_name}.sqre" \
          \( -size 500x500 xc:white -fill "rgba(0,0,0,0.7)" \
          -draw "polygon 400,500 500,500 500,0 450,0" \
          -fill black \
          -draw "polygon 500,500 500,0 450,500" \) \
          -alpha Off -compose CopyOpacity -composite \
          "''${THUMBS_DIR}/''${wall_name}.png" &&
        mv "''${THUMBS_DIR}/''${wall_name}.png" "''${THUMBS_DIR}/''${wall_name}.quad"

      [[ -f "''${CACHE_DIR}/''${wall_name}.blur" ]] && rm -rf "''${CACHE_DIR}/''${wall_name}.blur"
      cp -r "''${THUMBS_DIR}/''${wall_name}.blur" "''${CACHE_DIR}/wall.blur"

      [[ -f "''${CACHE_DIR}/''${wall_name}.quad" ]] && rm -rf "''${CACHE_DIR}/''${wall_name}.quad"
      cp -r "''${THUMBS_DIR}/''${wall_name}.quad" "''${CACHE_DIR}/wall.quad"
    }

    # Process the current wallpaper
    fn_wallcache "''${currentWall_name}" "''${input_file}"

    if [ ! -f "''${THUMBS_DIR}/''${currentWall_name}.quad" ]; then
      exit 1
    fi
  '';
}

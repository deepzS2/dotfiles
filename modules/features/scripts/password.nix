{
  flake.modules.homeManager.scripts = {pkgs, ...}: {
    home.packages = [
      (
        pkgs.writeShellApplication {
          name = "passmenu";
          runtimeInputs = [
            pkgs.rofi
            pkgs.passage
            pkgs.rage
            pkgs.pinentry-qt
          ];

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
    ];
  };
}

{
  flake.modules.homeManager.scripts = {pkgs, ...}: {
    home.packages = [
      pkgs.wl-clipboard
      pkgs.wl-clip-persist
      pkgs.cliphist
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
    ];
  };
}

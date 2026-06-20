{
  flake.modules.homeManager.scripts = {pkgs, ...}: {
    home.packages = [
      (
        pkgs.writeShellApplication {
          name = "initialize_setup";

          text = ''
            # Execute helper to background
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

            # Wait for awww-daemon to be ready
            sleep 1

            # Restore last theme if available
            if theme-switcher --restore 2>/dev/null; then
              send_notification notify "Theme restored"
            fi
          '';
        }
      )
    ];
  };
}

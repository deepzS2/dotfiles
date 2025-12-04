{
  flake.modules.homeManager.scripts = {pkgs, ...}: {
    home.packages = [
      (
        pkgs.writeShellApplication {
          name = "initialize_setup";

          text = ''
            send_notification sys
            swww-daemon &

            # Wait for swww-daemon to be ready
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

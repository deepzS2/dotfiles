{
  flake.modules.homeManager.scripts = {pkgs, ...}: {
    home.packages = [
      (
        pkgs.writeShellApplication {
          name = "initialize_setup";

          text = ''
            send_notification sys
            swww-daemon
          '';
        }
      )
    ];
  };
}

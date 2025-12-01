{config, ...}: let
  inherit (config.flake) assets;
in {
  flake.modules.homeManager.scripts = {pkgs, ...}: {
    home.packages = [
      (
        pkgs.writeShellApplication {
          name = "initialize_setup";

          runtimeInputs = [
            pkgs.swww
          ];
          text = ''
            send_notification sys

            swww-daemon &
            sleep 0.5
            swww img ${assets.media}/wallpapers/yakuza.jpg
          '';
        }
      )
    ];
  };
}

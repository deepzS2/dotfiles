# Startup script for Home Manager
# Exported as flake.modules.homeManager.script-startup
{config, ...}: let
  inherit (config.flake.settings) window-manager;
in {
  flake.modules.homeManager.scripts = {pkgs, ...}: {
    home.packages = [
      (
        pkgs.writeShellApplication {
          name = "initialize_setup";
          text = ''
            send_notification sys
          '';
        }
      )
    ];
  };
}

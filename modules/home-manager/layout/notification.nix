# Notification daemon configuration module for Home Manager
# Exported as flake.modules.homeManager.notification
{
  flake.modules.homeManager.notification = 
{
  config,
  lib,
  ...
}: let
  cfg = config.layout.notification;
in {
  options = {
    layout.notification.enable = lib.mkEnableOption "Mako notification daemon";
  };

  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
      settings = {
        sort = "-time";
        layer = "overlay";
        border-size = 2;
        border-radius = 4;
        icons = true;

        width = 400;

        default-timeout = 5000;
        ignore-timeout = true;

        anchor = "top-right";

        "mode=do-not-disturb" = {
          invisible = 1;
        };
      };
    };
  };
}
;
}

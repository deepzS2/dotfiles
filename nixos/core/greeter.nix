{
  pkgs,
  config,
  lib,
  self,
  ...
}: let
  tuigreetConfig = "${self}/config/tuigreet.toml";
  inherit (config) window-manager;
in {
  environment.systemPackages = [pkgs.tuigreet];
  qt.enable = true;

  services = {
    xserver.enable = true;

    greetd = {
      enable = true;
      settings = {
        terminal = {
          vt = 1;
        };
        default_session = {
          command = "${lib.getExe pkgs.tuigreet} --cmd ${window-manager} --config ${tuigreetConfig}";
          user = "deepz";
        };
      };
    };
  };
}

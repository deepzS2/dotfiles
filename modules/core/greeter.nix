{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.nixos.core = {
    pkgs,
    config,
    lib,
    ...
  }: let
    tuigreetConfig = "${directories.config}/tuigreet.toml";
    inherit (config) window-manager;
  in {
    environment.systemPackages = [pkgs.tuigreet];
    qt.enable = true;

    services = {
      # Enable the X11 windowing system.
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
  };
}

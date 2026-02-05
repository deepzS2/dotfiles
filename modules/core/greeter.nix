{
  inputs,
  config,
  ...
}: let
  inherit (config.flake) assets;
in {
  flake.modules.nixos.core = {
    pkgs,
    config,
    lib,
    ...
  }: let
    tuigreetPkg = inputs.tuigreet.packages.${pkgs.stdenv.hostPlatform.system}.tuigreet;
    tuigreetConfig = "${assets.path}/tuigreet.toml";
    inherit (config.settings) wm;
  in {
    environment.systemPackages = [tuigreetPkg];
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
            command = "${lib.getExe tuigreetPkg} --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session --cmd ${wm} --config ${tuigreetConfig}";
            user = "deepz";
          };
        };
      };
    };
  };
}

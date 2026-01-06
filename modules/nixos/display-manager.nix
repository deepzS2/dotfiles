{
  inputs,
  config,
  ...
}: let
  inherit (config.flake) assets;
  inherit (config.flake.settings) window-manager;
in {
  flake.modules.nixos.display-manager = {
    pkgs,
    config,
    lib,
    ...
  }: let
    tuigreetPkg = inputs.tuigreet.packages.${pkgs.stdenv.hostPlatform.system}.tuigreet;
    tuigreetConfig = "${assets.path}/tuigreet.toml";
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
            command = "${lib.getExe tuigreetPkg} --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session --cmd ${window-manager} --config ${tuigreetConfig}";
            user = "deepz";
          };
        };
      };
    };
  };
}

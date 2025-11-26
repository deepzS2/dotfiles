{
  inputs,
  config,
  ...
}: let
  # We inherit assets here so the homeManager config don't overwrite it.
  inherit (config.flake) assets;
in {
  flake.modules.homeManager.bar = {pkgs, ...}: {
    home.packages = [
      inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.brightnessctl
      pkgs.networkmanagerapplet
      pkgs.pavucontrol
    ];

    # Bluetooth Manager
    services.blueman-applet.enable = true;

    home.file.".config/quickshell" = {
      source = "${assets.path}/quickshell";
      recursive = true;
    };
  };
}

# Intel graphics driver configuration module for NixOS
# Exported as flake.modules.nixosModules.drivers-intel
{
  flake.modules.nixosModules.drivers-intel = 
{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.drivers.intel;
in {
  options.drivers.intel = {
    enable = lib.mkEnableOption "Enable Intel Graphics Drivers";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
    };

    # OpenGL
    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
        libva
        libva-utils
      ];
    };
  };
}
;
}

{
  flake.modules.nixos.drivers-intel = {pkgs, ...}: {
    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
    };

    hardware.graphics.extraPackages = builtins.attrValues {
      inherit (pkgs) intel-media-driver libvdpau-va-gl libva libva-utils;
    };
  };
}

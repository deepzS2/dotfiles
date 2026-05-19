{
  flake.modules.nixos = {
    core = {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    amd = {pkgs, ...}: {
      systemd.tmpfiles.rules = ["L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"];
      services.xserver.videoDrivers = ["amdgpu"];

      hardware.graphics.extraPackages = [
        pkgs.libva
        pkgs.libva-utils
      ];
    };

    intel = {pkgs, ...}: {
      nixpkgs.config.packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
      };

      hardware.graphics.extraPackages = builtins.attrValues {
        inherit (pkgs) intel-media-driver libvdpau-va-gl libva libva-utils;
      };
    };

    nvidia = {pkgs, ...}: {
      # Enable NVIDIA proprietary drivers
      services.xserver.videoDrivers = ["nvidia"];

      # Hardware acceleration and graphics support
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = builtins.attrValues {
          inherit (pkgs) libva-vdpau-driver libvdpau libvdpau-va-gl nvidia-vaapi-driver vdpauinfo libva libva-utils;
        };
      };

      hardware.nvidia = {
        # Modesetting is required for most wayland compositors
        modesetting.enable = true;

        # Power management (experimental, can cause sleep/suspend issues)
        powerManagement.enable = false;
        powerManagement.finegrained = false;

        # NVIDIA persistence daemon
        nvidiaPersistenced = false;

        # Use proprietary driver (open = false) or open-source (open = true)
        open = false;

        # Enable nvidia-settings GUI
        nvidiaSettings = true;
      };
    };
  };
}

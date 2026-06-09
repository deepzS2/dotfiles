{
  flake.modules.nixos = {
    core = {
      pkgs,
      lib,
      ...
    }: {
      hardware.graphics = let
        essentialPackages = [
          pkgs.libva
          pkgs.libva-utils
          pkgs.vulkan-loader
          pkgs.libGL
          pkgs.libGLU # for very old pre-2005 OpenGL games
        ];
      in {
        enable = true;
        enable32Bit = true;
        extraPackages = lib.mkDefault essentialPackages;
        extraPackages32 = lib.mkDefault essentialPackages;
      };
    };

    amd = {pkgs, ...}: {
      systemd.tmpfiles.rules = ["L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"];
      services.xserver.videoDrivers = ["amdgpu"];
    };

    intel = {pkgs, ...}: {
      nixpkgs.config.packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
      };

      hardware.graphics.extraPackages = builtins.attrValues {
        inherit (pkgs) intel-media-driver libvdpau-va-gl mesa;
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
          inherit (pkgs) libva-vdpau-driver libvdpau libvdpau-va-gl nvidia-vaapi-driver vdpauinfo;
        };
      };

      hardware.nvidia = {
        open = false;
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true; # Lets you use `nvidia-offload %command%` in steam
          };
          amdgpuBusId = "PCI:05:0:0";
          nvidiaBusId = "PCI:01:00:0";
        };
      };
    };
  };
}

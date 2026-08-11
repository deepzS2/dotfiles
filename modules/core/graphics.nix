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

    nvidia = {
      pkgs,
      lib,
      config,
      ...
    }: let
      inherit (lib.types) str enum submodule;
      inherit (lib) mkOption mkEnableOption;
      cfg = config.hardware.graphics.nvidia;
    in {
      options.hardware.graphics.nvidia = {
        prime = mkOption {
          type = enum ["offload" "sync"];
          default = "sync";
          example = "offload";
          description = "Prime mode (offload or sync)";
        };

        open = mkEnableOption "Enable open source kernel";
        powerManagement.enable = mkEnableOption "Enable power management through systemd";

        busId = mkOption {
          description = "Bus IDs of each GPU for Prime.";
          default = {};
          type = submodule {
            options = {
              nvidia = mkOption {
                type = str;
                example = "PCI:1@0:0:0";
                default = "";
                description = "Bus ID of NVIDIA GPU. Use lspci to find it.";
              };

              amd = mkOption {
                type = str;
                example = "PCI:4@0:0:0";
                default = "";
                description = "Bus ID of AMD GPU. Use lspci to find it.";
              };

              intel = mkOption {
                type = str;
                example = "PCI:0@0:2:0";
                default = "";
                description = "Bus ID of Intel GPU. Use lspci to find it.";
              };
            };
          };
        };
      };

      config = {
        services.xserver.videoDrivers = ["nvidia"];

        hardware.graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = builtins.attrValues {
            inherit (pkgs) libva-vdpau-driver libvdpau libvdpau-va-gl vdpauinfo;
          };
        };

        hardware.nvidia = {
          open = cfg.open;
          modesetting.enable = true;
          powerManagement.enable = cfg.powerManagement.enable;

          prime = {
            sync.enable = (cfg.prime == "sync");
            offload = lib.mkIf (cfg.prime == "offload") {
              enable = true;
              enableOffloadCmd = true; # Lets you use `nvidia-offload %command%` in steam
            };

            amdgpuBusId = cfg.busId.amd;
            nvidiaBusId = cfg.busId.nvidia;
            intelBusId = cfg.busId.intel;
          };
        };
      };
    };
  };
}

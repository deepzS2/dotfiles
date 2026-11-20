{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.types) str enum submodule;
  inherit (lib) mkOption mkEnableOption mkIf;
  cfg = config.hardware.graphics.nvidia;
in {
  options.hardware.graphics.nvidia = {
    prime = mkOption {
      type = enum ["offload" "sync"];
      default = "sync";
      example = "offload";
      description = "Prime mode (offload or sync)";
    };

    open = mkEnableOption "open source kernel";
    powerManagement.enable = mkEnableOption "power management through systemd";

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
        };
      };
    };
  };

  config = {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.graphics.extraPackages = builtins.attrValues {
      inherit (pkgs) libva-vdpau-driver libvdpau libvdpau-va-gl vdpauinfo;
    };

    hardware.nvidia = {
      inherit (cfg) open;
      modesetting.enable = true;
      powerManagement.enable = cfg.powerManagement.enable;

      prime = {
        sync.enable = cfg.prime == "sync";
        offload = mkIf (cfg.prime == "offload") {
          enable = true;
          enableOffloadCmd = true; # Lets you use `nvidia-offload %command%` in steam
        };

        amdgpuBusId = cfg.busId.amd;
        nvidiaBusId = cfg.busId.nvidia;
      };
    };
  };
}

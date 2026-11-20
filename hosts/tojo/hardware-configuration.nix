{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/3660e764-3cb3-4d94-b61c-e9018b61a12e";
      fsType = "btrfs";
      options = ["compress=zstd:3"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/3660e764-3cb3-4d94-b61c-e9018b61a12e";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd:3"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/3660e764-3cb3-4d94-b61c-e9018b61a12e";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd:3" "noatime"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/9617-80A6";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/1e22437d-a997-4ab7-9046-5ba069a7d06c";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

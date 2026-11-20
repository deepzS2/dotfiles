{inputs, ...}: {
  flake.modules.nixos.core = {
    lib,
    config,
    pkgs,
    ...
  }: let
    cfg = config.bootloader;
  in {
    options.bootloader = {
      secure.enable = lib.mkEnableOption "Enable secure boot";
      windows.enable = lib.mkEnableOption "Enable Windows boot entry (need to be in the boot path)";
    };

    config = {
      nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];

      boot = {
        kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest; # Cachy Kernel

        loader = {
          efi.canTouchEfiVariables = true;
          limine = {
            enable = true;
            maxGenerations = 3;
            secureBoot.enable = cfg.secure.enable;
            extraEntries = ''
              /Windows
                  protocol: efi
                  path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
                  comment: Boot into Windows
            '';
          };
        };
      };
    };
  };
}

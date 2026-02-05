{
  flake.modules.nixos.core = {
    lib,
    config,
    ...
  }: let
    cfg = config.bootloader;
  in {
    options.bootloader = {
      withSecure = lib.mkEnableOption "Enable secure boot";
      withWindows = lib.mkEnableOption "Add Windows 11 boot entry";
    };

    config = {
      boot.loader = {
        efi.canTouchEfiVariables = true;
        limine = {
          enable = true;
          maxGenerations = 3;
          secureBoot.enable = cfg.withSecure;
          extraConfig = lib.mkIf cfg.withWindows ''
            default_entry: 0
            /Windows 11
                protocol: efi
                path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
                comment: Boot into Windows 11
          '';
        };
      };
    };
  };
}

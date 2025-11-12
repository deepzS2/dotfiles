{
  config,
  inputs,
  ...
}: {
  flake.modules.nixos.deepz = {pkgs, ...}: {
    imports =
      [
        inputs.home-manager.nixosModules.default
        inputs.niri.nixosModules.niri
      ]
      ++ (with config.flake.modules.nixos; [
        audio
        display-manager
        drivers-nvidia
        fonts
        nix
        locale
        network
        podman
        hyprland
        niri
        notifications
      ]);

    # Bootloader (with secure boot).
    boot.loader = {
      efi.canTouchEfiVariables = true;
      limine = {
        enable = true;
        maxGenerations = 3;
        secureBoot.enable = true;
        style.wallpapers = [../../../config/theme/wallpapers/limine-wallpaper.png];
        extraConfig = ''
          default_entry: 0
          /Windows 11
              protocol: efi
              path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
              comment: Boot into Windows 11
        '';
      };
    };

    # Graphics driver
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Define a user account. Don't forget to set a password with 'passwd'.
    environment.shells = [pkgs.nushell];
    users = {
      defaultUserShell = pkgs.nushell;
      users.deepz = {
        isNormalUser = true;
        description = "Alan";
        extraGroups = ["networkmanager" "wheel" "audio" "docker"];
      };
    };

    home-manager.users."deepz" = config.flake.modules.homeManager.deepz;

    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) vim wget sbctl firefox;
    };

    system.stateVersion = "25.05";
  };
}

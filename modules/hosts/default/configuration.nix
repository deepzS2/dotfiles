{
  pkgs,
  inputs,
  system,
  self,
  ...
}: {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ]
    ++ (with self.modules.nixosModules; [
      audio
      containers
      display-manager
      drivers-nvidia
      fonts
      locale
      network
    ]);

  # Bootloader (with secure boot).
  boot.loader.limine = {
    enable = true;
    maxGenerations = 3;
    secureBoot.enable = true;
    style.wallpapers = [../../config/theme/wallpapers/limine-wallpaper.png];
    extraConfig = ''
      default_entry: 0
      /Windows 11
          protocol: efi
          path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
          comment: Boot into Windows 11
    '';
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # Graphics driver
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  environment.shells = [pkgs.nushell];
  users.users.deepz = {
    isNormalUser = true;
    description = "Alan";
    extraGroups = ["networkmanager" "wheel" "audio" "docker"];
    shell = pkgs.nushell;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs system self;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bkp";
    users = {
      "deepz" = import ./home.nix;
    };
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    sbctl
  ];

  system.stateVersion = "25.05";
}

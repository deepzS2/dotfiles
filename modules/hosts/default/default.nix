{self, ...}: {
  flake.modules = {
    nixos.default = {
      pkgs,
      inputs,
      ...
    }: {
      imports =
        [
          ./default/hardware-configuration.nix
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

      # Define a user account. Don't forget to set a password with 'passwd'.
      environment.shells = [pkgs.nushell];
      users.users.deepz = {
        isNormalUser = true;
        description = "Alan";
        extraGroups = ["networkmanager" "wheel" "audio" "docker"];
        shell = pkgs.nushell;
      };

      home-manager = {
        extraSpecialArgs = {inherit inputs self;};
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bkp";
        users = {
          "deepz" = self.modules.homeManager.default;
        };
      };

      programs.firefox.enable = true;

      environment.systemPackages = with pkgs; [
        vim
        wget
        sbctl
      ];

      system.stateVersion = "25.05";
    };

    homeManager.default = {inputs, ...}: {
      imports =
        [
          inputs.zen-browser.homeModules.beta
          inputs.nixCats.homeModule
          inputs.stylix.homeModules.stylix
          inputs.agenix.homeManagerModules.default
        ]
        ++ (with self.modules.homeManager; [
          git
          # Applications
          browser
          discord
          obs
          terminal
          video-player
          # Development
          elixir
          go
          javascript
          rust
          # Editor
          vscode
          nvim
          # Shell
          ai
          btop
          fastfetch
          nushell
          prompt
          tmux
          # Layout
          notification
          rofi
          theme
          wallpaper
          waybar
          # Hyprland
          hypridle
          hyprland
          hyprlock
          # Scripts
          script-clipboard
          script-notification
          script-powermenu
          script-startup
          script-wallpaper-cache
          script-wallpaper-load
          script-wallpaper-select
          script-wifimenu
          # Secrets
          nix-helper
          secrets
        ]);

      home.stateVersion = "25.05";
      programs.home-manager.enable = true;
      home.username = "deepz";
      home.homeDirectory = "/home/deepz";
      home.sessionVariables = {};
    };
  };
}

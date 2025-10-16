{
  description = "My Nix configuration - by deepz";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Flake-parts for modular flake configuration
    flake-parts.url = "github:hercules-ci/flake-parts";
    
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # VSCode
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Secrets management
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      # Import all modules - they will self-register in flake.modules
      imports = [
        # Flake-parts operational modules (define flake outputs directly)
        ./modules/flake/nixos-configurations.nix
        ./modules/flake/overlays.nix
        ./modules/flake/formatter.nix
        ./modules/flake/packages.nix
        ./modules/flake/dev-shells.nix
        
        # Home Manager modules (self-register as flake.modules.homeManager.*)
        # Core
        ./modules/home-manager/git.nix
        ./modules/home-manager/nix-helper.nix
        ./modules/home-manager/secrets.nix
        # Applications
        ./modules/home-manager/applications/browser.nix
        ./modules/home-manager/applications/discord.nix
        ./modules/home-manager/applications/obs.nix
        ./modules/home-manager/applications/terminal.nix
        ./modules/home-manager/applications/video-player.nix
        # Development
        ./modules/home-manager/development/elixir.nix
        ./modules/home-manager/development/go.nix
        ./modules/home-manager/development/javascript.nix
        ./modules/home-manager/development/rust.nix
        # Editor
        ./modules/home-manager/editor/vscode.nix
        ./modules/home-manager/editor/nvim.nix
        # Shell
        ./modules/home-manager/shell/ai.nix
        ./modules/home-manager/shell/btop.nix
        ./modules/home-manager/shell/fastfetch.nix
        ./modules/home-manager/shell/nushell.nix
        ./modules/home-manager/shell/prompt.nix
        ./modules/home-manager/shell/tmux.nix
        # Layout
        ./modules/home-manager/layout/notification.nix
        ./modules/home-manager/layout/rofi.nix
        ./modules/home-manager/layout/theme.nix
        ./modules/home-manager/layout/wallpaper.nix
        ./modules/home-manager/layout/waybar.nix
        # Hyprland
        ./modules/home-manager/layout/hyprland/hypridle.nix
        ./modules/home-manager/layout/hyprland/hyprland.nix
        ./modules/home-manager/layout/hyprland/hyprlock.nix
        # Scripts
        ./modules/home-manager/layout/scripts/clipboard.nix
        ./modules/home-manager/layout/scripts/notification.nix
        ./modules/home-manager/layout/scripts/powermenu.nix
        ./modules/home-manager/layout/scripts/startup.nix
        ./modules/home-manager/layout/scripts/wallpaper_cache.nix
        ./modules/home-manager/layout/scripts/wallpaper_load.nix
        ./modules/home-manager/layout/scripts/wallpaper_select.nix
        ./modules/home-manager/layout/scripts/wifimenu.nix
        
        # NixOS modules (self-register as flake.modules.nixosModules.*)
        ./modules/nixos/audio.nix
        ./modules/nixos/containers.nix
        ./modules/nixos/display-manager.nix
        ./modules/nixos/fonts.nix
        ./modules/nixos/locale.nix
        ./modules/nixos/network.nix
        # Drivers
        ./modules/nixos/drivers/amd.nix
        ./modules/nixos/drivers/intel.nix
        ./modules/nixos/drivers/nvidia.nix
      ];

      # Define systems to support
      systems = ["x86_64-linux"];

      # Per-system configuration
      perSystem = {
        config,
        system,
        pkgs,
        ...
      }: {
        # This will be populated by individual modules
      };
    };
}

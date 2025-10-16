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
      # Import all flake-parts modules from modules/flake/
      imports = [
        ./modules/flake/nixos-configurations.nix
        ./modules/flake/overlays.nix
        ./modules/flake/formatter.nix
        ./modules/flake/packages.nix
        ./modules/flake/dev-shells.nix
      ];

      # Define systems to support
      systems = ["x86_64-linux"];

      # Export modules organized by class
      flake.modules = {
        # Generic modules - can be used in any flake-parts configuration
        generic = {
          nixos-configurations = ./modules/flake/nixos-configurations.nix;
          overlays = ./modules/flake/overlays.nix;
          formatter = ./modules/flake/formatter.nix;
          packages = ./modules/flake/packages.nix;
          dev-shells = ./modules/flake/dev-shells.nix;
        };

        # NixOS modules - for NixOS system configuration
        nixosModules = {
          audio = ./modules/nixos/audio.nix;
          containers = ./modules/nixos/containers.nix;
          display-manager = ./modules/nixos/display-manager.nix;
          fonts = ./modules/nixos/fonts.nix;
          locale = ./modules/nixos/locale.nix;
          network = ./modules/nixos/network.nix;
          drivers = ./modules/nixos/drivers;
        };

        # Home Manager modules - for home-manager configuration
        homeModules = {
          git = ./modules/home-manager/git.nix;
          nix-helper = ./modules/home-manager/nix-helper.nix;
          secrets = ./modules/home-manager/secrets.nix;
          applications = ./modules/home-manager/applications;
          development = ./modules/home-manager/development;
          editor = ./modules/home-manager/editor;
          layout = ./modules/home-manager/layout;
          shell = ./modules/home-manager/shell;
        };
      };

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

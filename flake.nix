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
        # Flake-parts modules
        ./modules/flake/nixos-configurations.nix
        ./modules/flake/overlays.nix
        ./modules/flake/formatter.nix
        ./modules/flake/packages.nix
        ./modules/flake/dev-shells.nix
        
        # Home Manager modules
        ./modules/home-manager/git.nix
        ./modules/home-manager/nix-helper.nix
        ./modules/home-manager/secrets.nix
        
        # NixOS modules
        ./modules/nixos/audio.nix
        ./modules/nixos/containers.nix
        ./modules/nixos/display-manager.nix
        ./modules/nixos/fonts.nix
        ./modules/nixos/locale.nix
        ./modules/nixos/network.nix
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

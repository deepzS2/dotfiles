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
      # Import all flake-parts modules
      imports = [
        ./parts/nixos-configurations.nix
        ./parts/overlays.nix
        ./parts/formatter.nix
        ./parts/packages.nix
        ./parts/dev-shells.nix
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

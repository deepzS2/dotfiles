{
  description = "My Nix configuration - by deepz";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flake-parts for modular flake configuration
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Automatic module tree importing
    import-tree.url = "github:vic/import-tree";

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

    # Devshell
    devshell.url = "github:numtide/devshell";

    # Secrets management
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}

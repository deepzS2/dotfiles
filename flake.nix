{
  description = "My Nix configuration - by deepz";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim and AI
    mnw.url = "github:Gerg-L/mnw";
    opencode.url = "github:sst/opencode";

    # Zen Browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Niri Window Manager
    niri.url = "github:sodiboo/niri-flake";
    niri-scratchpad.url = "github:argosnothing/niri-scratchpad-rs";

    # Theming and greetd
    matugen = {
      url = "github:/InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tuigreet = {
      url = "github:NotAShelf/tuigreet";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop shell
    sheez = {
      url = "github:deepzS2/sheez";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noogle TUI
    noogle-search.url = "github:argosnothing/noogle-search";

    # My secrets (in private repo)
    nix-secrets = {
      url = "git+ssh://git@github.com/deepzS2/nix-secrets.git";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}

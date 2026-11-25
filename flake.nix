{
  description = "My Nix configuration - by deepz";

  inputs = {
    adios-flake.url = "github:Mic92/adios-flake";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";

    # Hjem
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nvim, Emacs and AI
    nvimz.url = "git+https://codeberg.org/deepzS2/nvimz";
    demacz.url = "git+https://codeberg.org/deepzS2/demacz";
    llm-agents.url = "github:numtide/llm-agents.nix";
    workmux.url = "github:raine/workmux";

    # Window managers
    niri.url = "github:sodiboo/niri-flake";
    niri-scratchpad = {
      url = "github:gvolpe/niri-scratchpad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theming and greetd
    matugen = {
      url = "github:/InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop shell
    sheez = {
      url = "github:deepzS2/sheez";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Cachy kernel patches
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    # Screenshare audio
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
  };

  outputs = inputs @ {
    self,
    adios-flake,
    ...
  }: let
    mkHost = import ./lib/mk-host.nix {inherit inputs self;};
  in
    adios-flake.lib.mkFlake {
      inherit inputs self;

      systems = ["x86_64-linux" "aarch64-linux"];
      modules = [./devshell.nix];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;

        packages = {
          kanagawa-gtk-theme = pkgs.callPackage ./packages/kanagawa-gtk-theme.nix {};
          mister-download-manager = pkgs.callPackage ./packages/mister-download-manager.nix {};
          tmux-sessionizer = pkgs.callPackage ./packages/tmux-sessionizer.nix {};
        };
      };

      flake.nixosConfigurations = {
        tojo = mkHost "tojo";
        omi = mkHost "omi";
      };
    };
}

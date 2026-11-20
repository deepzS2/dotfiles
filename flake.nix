{
  description = "My Nix configuration - by deepz";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
    flake-parts.url = "github:hercules-ci/flake-parts";

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
  };

  outputs = inputs @ {flake-parts, ...}: let
    inherit (inputs.nixpkgs) lib;

    importTree = dir: let
      rel = p: lib.removePrefix (toString dir) (toString p);
      isModule = p: let r = rel p; in lib.hasSuffix ".nix" r && !lib.hasInfix "/_" r;
    in
      map import (lib.filter isModule (lib.filesystem.listFilesRecursive dir));
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = importTree ./modules;
    };
}

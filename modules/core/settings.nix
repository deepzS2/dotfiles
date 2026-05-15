{inputs, ...}: let
  common = {
    nixpkgs.config.allowUnfree = true;

    nix = {
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];

      settings = {
        experimental-features = ["nix-command" "flakes"];
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://niri.cachix.org"
          "https://cache.numtide.com"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];
      };
    };
  };
in {
  flake.modules.nixos.core = {
    pkgs,
    lib,
    ...
  }:
    lib.mkMerge [
      common
      {
        environment.systemPackages = [pkgs.libnotify pkgs.vim pkgs.wget pkgs.sbctl pkgs.firefox]; # Default packages
        services.printing.enable = true; # Enable CUPS to print documents.

        nixpkgs.overlays = [inputs.niri.overlays.niri];
      }
    ];

  flake.modules.homeManager.core = {
    pkgs,
    lib,
    ...
  }:
    lib.mkMerge [
      common
      {
        nix.package = lib.mkDefault pkgs.nix;
      }
    ];
}

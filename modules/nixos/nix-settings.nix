{inputs, ...}: {
  flake.modules.nixos.nix = {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Overlays
    nixpkgs.overlays = [inputs.niri.overlays.niri];

    nix = {
      # For nix LSP
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];

      # Enable Flakes
      settings.experimental-features = ["nix-command" "flakes"];

      # Binary caches for faster builds
      settings = {
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };
  };
}

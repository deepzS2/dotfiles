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
    };
  };
}

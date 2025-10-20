{
  flake.modules.homeManager.nix = {inputs, ...}: {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    nix = {
      # For nix LSP
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];

      # Enable Flakes
      settings.experimental-features = ["nix-command" "flakes"];
    };
  };
}

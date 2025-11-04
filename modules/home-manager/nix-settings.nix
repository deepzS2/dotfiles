{inputs, ...}: {
  flake.modules.homeManager.nix = {
    pkgs,
    lib,
    ...
  }: {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    nix = {
      # It is mandatory in home manager standalone
      package = lib.mkDefault pkgs.nix;

      # For nix LSP
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];

      # Enable Flakes
      settings.experimental-features = ["nix-command" "flakes"];
    };
  };
}

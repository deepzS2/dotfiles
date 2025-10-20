# NixOS system configurations module for flake-parts
# This module defines all NixOS system configurations
{
  inputs,
  withSystem,
  ...
}: {
  flake.nixosConfigurations = {
    # Default system configuration
    default = withSystem "x86_64-linux" (
      {
        inputs',
        ...
      }:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs inputs';};
          modules = [
            # Host configuration from flake.modules
            inputs.self.modules.nixos.default

            # Global Nix settings
            {
              # Allow unfree packages
              nixpkgs.config.allowUnfree = true;

              nix = {
                # For nix LSP
                nixPath = ["nixpkgs=${inputs.nixpkgs}"];

                # Garbage collector
                gc = {
                  automatic = true;
                  dates = "weekly";
                  options = "--delete-older-than 7d";
                };

                # Enable Flakes
                settings.experimental-features = ["nix-command" "flakes"];
              };
            }
          ];
        }
    );
  };
}

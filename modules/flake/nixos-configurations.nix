# NixOS system configurations module for flake-parts
# This module defines all NixOS system configurations
{
  inputs,
  self,
  withSystem,
  ...
}: {
  flake.nixosConfigurations = {
    # Default system configuration
    default = withSystem "x86_64-linux" (
      {system, ...}:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs system self;};
          modules = [
            # Host configuration
            ../hosts/default/configuration.nix

            # Overlays
            ../../overlays

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

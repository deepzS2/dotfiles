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
      {system, ...}:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs system;};
          modules = [
            # Host configuration
            ../hosts/default/configuration.nix

            # Overlays
            (import ../overlays)

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

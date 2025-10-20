# Host configurations module for flake-parts
# This module defines all NixOS and Home Manager configurations
{
  inputs,
  withSystem,
  ...
}: {
  flake.nixosConfigurations = {
    # Default system configuration
    default = inputs.nixpkgs.lib.nixosSystem {
      specialArgs.inputs = inputs;
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
    };
  };

  flake.homeConfigurations = {
    default = withSystem "x86_64-linux" (
      {pkgs, ...}:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            self = inputs.self;
          };
          modules = [inputs.self.modules.homeManager.default];
        }
    );
  };
}

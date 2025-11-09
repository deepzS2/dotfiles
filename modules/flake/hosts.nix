# Host configurations module for flake-parts
# This module defines all NixOS and Home Manager configurations
{
  inputs,
  withSystem,
  ...
}: {
  flake.nixosConfigurations = {
    # Default system configuration
    deepz = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # Host configuration from flake.modules
        inputs.self.modules.nixos.deepz
      ];
    };
  };

  flake.homeConfigurations = {
    "deepz@alan" = withSystem "x86_64-linux" (
      _:
        inputs.home-manager.lib.homeManagerConfiguration {
          modules = [inputs.self.modules.homeManager.deepz];
        }
    );
  };
}

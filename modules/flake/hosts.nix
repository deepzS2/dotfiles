# Host configurations module for flake-parts
# This module defines all NixOS and Home Manager configurations
{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations = {
    # Default system configuration
    deepz = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # Host configuration from flake.modules
        config.flake.modules.nixos.deepz
      ];
    };
  };

  flake.homeConfigurations = {
    "deepz@alan" = inputs.home-manager.lib.homeManagerConfiguration {
      modules = [config.flake.modules.homeManager.deepz];
    };
  };
}

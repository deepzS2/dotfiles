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
      specialArgs.inputs = inputs;
      modules = [
        # Host configuration from flake.modules
        inputs.self.modules.nixos.default
      ];
    };
  };

  flake.homeConfigurations = {
    "deepz@alan" = withSystem "x86_64-linux" (
      {
        pkgs,
        system,
        ...
      }:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {inherit inputs system;};
          modules = [inputs.self.modules.homeManager.default];
        }
    );
  };
}

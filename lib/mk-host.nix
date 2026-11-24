{
  inputs,
  self,
}: host: let
  importTree = import ./import-tree.nix inputs.nixpkgs.lib;
in
  inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs self;};

    modules =
      [
        inputs.hjem.nixosModules.default
        ../hosts/${host}
      ]
      ++ importTree ../nixos/core;
  }

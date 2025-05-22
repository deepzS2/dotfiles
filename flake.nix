{
  description = "NixOS + standalone home-manager config flakes to get you started!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...}@inputs: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [
          ./hosts/default/configuration.nix
          {
            # Allow unfree packages
            nixpkgs.config.allowUnfree = true;

            nix = {
              # For nix LSP
              nixPath = ["nixpkgs=${inputs.nixpkgs}"];

              # Enable Flakes
              settings.experimental-features = ["nix-command" "flakes"];
            };
          }
        ];
      };
    };
    formatter = pkgs.alejandra;
  };
}

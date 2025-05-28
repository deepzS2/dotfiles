{
  description = "NixOS + standalone home-manager config flakes to get you started!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # VSCode
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, nix-vscode-extensions,  ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system;};
        modules = [
          ./hosts/default/configuration.nix
          {
            # Allow unfree packages
            nixpkgs.config.allowUnfree = true;

            # VSCode overlay
            nixpkgs.overlays = [
              nix-vscode-extensions.overlays.default
            ];

            nix = {
              # For nix LSP
              nixPath = ["nixpkgs=${nixpkgs}"];

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

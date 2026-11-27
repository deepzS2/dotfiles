{
  description = "dotz - deepz nixos configurations";

  outputs = {self}: let
    inputs = import ./.tack {};

    inherit (inputs) adios-flake;

    mkHost = import ./lib/mk-host.nix {inherit inputs self;};
  in
    adios-flake.lib.mkFlake {
      inherit inputs self;

      systems = ["x86_64-linux" "aarch64-linux"];
      modules = [./devshell];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;

        packages = pkgs.lib.packagesFromDirectoryRecursive {
          callPackage = pkgs.callPackage;
          directory = ./packages;
        };
      };

      flake.nixosConfigurations = {
        tojo = mkHost "tojo";
        omi = mkHost "omi";
      };
    };
}

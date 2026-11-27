{
  description = "dotz - deepz nixos configurations";

  outputs = {self, ...} @ args: let
    pins = (import ./.tack) {
      overrides = args.tackOverrides or {};
    };

    inputs =
      removeAttrs pins [
        "_meta"
        "_patched"
        "__functor"
      ]
      // {inherit self;};

    inherit (inputs) adios-flake;

    mkHost = import ./lib/mk-host.nix {inherit inputs self;};
  in
    adios-flake.lib.mkFlake {
      inherit inputs self;

      systems = ["x86_64-linux" "aarch64-linux"];
      modules = [./devshell];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;

        packages = {
          kanagawa-gtk-theme = pkgs.callPackage ./packages/kanagawa-gtk-theme.nix {};
          mister-download-manager = pkgs.callPackage ./packages/mister-download-manager.nix {};
          tmux-sessionizer = pkgs.callPackage ./packages/tmux-sessionizer.nix {};
        };
      };

      flake.nixosConfigurations = {
        tojo = mkHost "tojo";
        omi = mkHost "omi";
      };
    };
}

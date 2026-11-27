{pkgs, ...}: let
  dotz = pkgs.writeShellApplication {
    name = "dotz";

    runtimeInputs = with pkgs; [
      git
      nh
      statix
      deadnix
      nix-inspect
      jq
    ];

    text = builtins.readFile ./dotz.sh;
  };
in {
  devShells.default = pkgs.mkShellNoCC {
    packages = with pkgs; [
      dotz
      alejandra
      nil
      statix
      deadnix
      git
      jq
      yq
      tree
      nix-inspect
      nh
    ];
  };
}

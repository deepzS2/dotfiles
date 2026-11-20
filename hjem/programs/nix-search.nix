{pkgs, ...}: let
  ns = pkgs.writeShellScriptBin "ns" (builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh");
in {
  packages = [
    ns
    pkgs.fzf
    pkgs.nix-search-tv
  ];
}

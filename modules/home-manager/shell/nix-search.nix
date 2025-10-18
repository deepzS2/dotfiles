# Nix search script module for Home Manager
# Provides the 'ns' command for searching nixpkgs
{
  flake.modules.homeManager.nix-search = {pkgs, ...}: let
    ns = pkgs.writeShellScriptBin "ns" (builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh");
  in {
    home.packages = [
      ns
      pkgs.fzf
      pkgs.nix-search-tv
    ];
  };
}

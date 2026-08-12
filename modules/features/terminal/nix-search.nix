{
  flake.modules.hjem.nix-search = {pkgs, ...}: let
    ns = pkgs.writeShellScriptBin "ns" (builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh");
  in {
    config.packages = [
      ns
      pkgs.fzf
      pkgs.nix-search-tv
    ];
  };
}

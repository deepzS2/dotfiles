{inputs, ...}: {
  flake.modules.homeManager.nix-search = {pkgs, ...}: let
    ns = pkgs.writeShellScriptBin "ns" (builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh");
  in {
    home.packages = [
      inputs.noogle-search.packages.${pkgs.stdenv.hostPlatform.system}.default
      ns
      pkgs.fzf
      pkgs.nix-search-tv
    ];
  };
}

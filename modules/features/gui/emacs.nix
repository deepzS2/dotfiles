{inputs, ...}: {
  flake.modules.homeManager.emacs = {pkgs, ...}: {
    home.packages = [
      inputs.demacz.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.hledger # Financial notes
    ];
  };
}

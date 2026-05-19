{
  flake.modules.homeManager.file-manager = {pkgs, ...}: {
    home.packages = [pkgs.nautilus];
  };
}

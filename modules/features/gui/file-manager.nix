{
  flake.modules.hjem.file-manager = {pkgs, ...}: {
    config.packages = [pkgs.nautilus];
  };
}

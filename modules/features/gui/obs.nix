{
  flake.modules.hjem.obs = {pkgs, ...}: {
    config.packages = [pkgs.obs-studio];
  };
}

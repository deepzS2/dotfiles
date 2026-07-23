{
  flake.modules.hjem.nh = {pkgs, ...}: {
    config.packages = [pkgs.nh];
  };
}

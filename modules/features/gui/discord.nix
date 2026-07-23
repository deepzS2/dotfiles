{
  flake.modules.hjem.discord = {pkgs, ...}: {
    config.packages = [pkgs.discord];
  };
}

{
  flake.modules.homeManager.dev = {pkgs, ...}: {
    home.packages = [pkgs.just pkgs.tokei];
  };
}

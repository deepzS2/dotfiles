{
  flake.modules.hjem.dev = {pkgs, ...}: {
    config.packages = [pkgs.just pkgs.tokei pkgs.gcc];
  };
}

{
  flake.modules.hjem.secrets = {pkgs, ...}: {
    config.packages = [pkgs.oama pkgs.offlineimap pkgs.age pkgs.passage];
  };
}

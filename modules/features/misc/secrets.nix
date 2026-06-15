{
  flake.modules.homeManager.secrets = {pkgs, ...}: {
    home.packages = [pkgs.oama pkgs.offlineimap pkgs.age pkgs.passage];
  };
}

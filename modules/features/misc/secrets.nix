{
  flake.modules.hjem.secrets = {pkgs, ...}: {
    config.packages = [pkgs.age pkgs.passage pkgs.keepassxc];
  };
}

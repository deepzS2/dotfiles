{
  flake.modules.nixos.docker = {pkgs, ...}: {
    environment = {
      systemPackages = [
        pkgs.docker-compose
      ];
    };

    virtualisation.docker = {
      enable = true;
    };
  };
}

{
  flake.modules.nixos.podman = {
    pkgs,
    ...
  }: {
    environment = {
      systemPackages = [
        pkgs.podman-compose
      ];

      sessionVariables = {
        DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
      };
    };

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
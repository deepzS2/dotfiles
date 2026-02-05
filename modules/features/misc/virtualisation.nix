{
  flake.modules.nixos.virtualisation = {
    pkgs,
    config,
    lib,
    ...
  }: let
    cfg = config.container;
  in {
    options.container = {
      engine = lib.mkOption {
        type = lib.types.enum ["docker" "podman"];
        default = "podman";
        example = "docker";
        description = "The container virtualisation engine to use";
      };
    };

    config = lib.mkMerge [
      (lib.mkIf (cfg.engine == "docker") {
        environment.systemPackages = [
          pkgs.docker-compose
        ];

        virtualisation.docker.enable = true;
      })

      (lib.mkIf (cfg.engine == "podman") {
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
      })
    ];
  };
}

{
  flake.modules.nixosModules.containers = {
    pkgs,
    lib,
    config,
    ...
  }: {
    options.containers = {
      backend = lib.mkOption {
        type = lib.types.enum ["podman" "docker"];
        default = "podman";
        description = "Container backend to use (podman or docker)";
      };
    };

    config = let
      cfg = config.containers;
      usePodman = cfg.backend == "podman";
      useDocker = cfg.backend == "docker";
    in {
      environment = {
        systemPackages =
          [
            (
              if usePodman
              then pkgs.podman-compose
              else pkgs.docker-compose
            )
          ]
          ++ lib.optionals usePodman [pkgs.podman-compose]
          ++ lib.optionals useDocker [pkgs.docker-compose];

        sessionVariables = lib.mkIf usePodman {
          DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
        };
      };

      virtualisation.podman = lib.mkIf usePodman {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      virtualisation.docker = lib.mkIf useDocker {
        enable = true;
      };
    };
  };
}

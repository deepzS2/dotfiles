# Container engine configuration module for NixOS
# Exported as flake.modules.nixosModules.containers
{
  flake.modules.nixosModules.containers = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.services.containerEngine;
  in {
    options = {
      services.containerEngine = lib.mkOption {
        type = lib.types.enum ["docker" "podman"];
        default = "podman";
        description = ''
          Which container engine to use.
          Choose "docker" or "podman".
        '';
      };
    };

    config =
      lib.mkIf (cfg == "docker") {
        virtualisation.docker.enable = true;
      }
      // lib.mkIf (cfg == "podman") {
        environment = {
          systemPackages = [
            pkgs.docker-compose
            pkgs.podman-compose
          ];
          sessionVariables = {
            DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
          };
        };

        virtualisation = {
          podman = {
            enable = true;
            # Create a `docker` alias for podman, to use it as a drop-in replacement
            dockerCompat = true;
            # Make the Podman socket available in place of the Docker socket, so Docker tools can find the Podman socket.
            dockerSocket.enable = true;
            # Required for containers under podman-compose to be able to talk to each other.
            defaultNetwork.settings.dns_enabled = true;
          };
        };
      };
  };
}

{ lib, config, ... }:
  let 
    cfg = config.services.containerEngine;
  in {
    options = {
      services.containerEngine = lib.mkOption {
        type = lib.types.enum [ "docker" "podman" ];
        default = "podman";
        description = ''
          Which container engine to use.
          Choose "docker" or "podman".
        '';
      };
    };

    config = lib.mkIf (cfg == "docker") {
      virtualisation.docker.enable = true;
    }
    // lib.mkIf (cfg == "podman") {
      virtualisation = {
        podman = {
          enable = true;
          # Create a `docker` alias for podman, to use it as a drop-in replacement
          dockerCompat = true;
          # Required for containers under podman-compose to be able to talk to each other.
          defaultNetwork.settings.dns_enabled = true;
        };
      };
    };
  }
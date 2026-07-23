{
  flake.modules.nixos.sync = {
    programs.localsend.enable = true;
  };

  flake.modules.hjem.sync = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.services.syncthing = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the Syncthing service.";
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "${config.directory}/.local/state/syncthing";
        description = "Data directory for Syncthing.";
      };

      configDir = lib.mkOption {
        type = lib.types.str;
        default = "${config.directory}/.config/syncthing";
        description = "Config directory for Syncthing.";
      };
    };

    config = let
      cfg = config.services.syncthing;
    in {
      packages = [pkgs.syncthing];

      systemd.services.syncthing = lib.mkIf cfg.enable {
        wantedBy = ["default.target"];
        unitConfig = {
          Description = "Syncthing - Open Source Continuous File Synchronization";
          Documentation = "man:syncthing(1)";
          After = ["network.target"];
          StartLimitIntervalSec = 60;
          StartLimitBurst = 4;
        };
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.syncthing} --no-browser --config=${cfg.configDir} --data=${cfg.dataDir}";
          Restart = "on-failure";
          SuccessExitStatus = [3 4];
          RestartForceExitStatus = [3 4];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateUsers = true;
          RestrictNamespaces = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = "@system-service";
        };
      };
    };
  };
}

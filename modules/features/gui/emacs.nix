{
  inputs,
  self,
  ...
}: let
  inherit (self) directories;
in {
  flake.modules.homeManager.emacs = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = [
      inputs.demacz.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.hledger # Financial notes
      pkgs.davmail # Reading my Outlook mails
    ];

    systemd.user.services.davmail = {
      Unit = {
        Description = "DavMail POP/IMAP/SMTP Exchange Gateway";
        After = [
          "graphical-session.target"
          "network.target"
        ];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        Type = "exec";
        ExecStart = "${lib.getExe pkgs.davmail} ${directories.config}/davmail.properties";
        Restart = "on-failure";

        CapabilityBoundingSet = [""];
        DeviceAllow = [""];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectSystem = "strict";
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        SystemCallErrorNumber = "EPERM";
        UMask = "0077";
      };
    };
  };
}

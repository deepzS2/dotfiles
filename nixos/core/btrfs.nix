{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.btdu
    pkgs.btrfs-assistant
    pkgs.timeshift
  ];

  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = ["/"];
    };

    snapper = {
      snapshotInterval = "hourly";
      cleanupInterval = "daily";
      configs = {
        home = {
          SUBVOLUME = "/home";
          SNAPSHOT_LIMIT_HOURLY = "5";
          SNAPSHOT_LIMIT_DAILY = "7";
          SNAPSHOT_LIMIT_WEEKLY = "4";
          SNAPSHOT_LIMIT_MONTHLY = "0";
          TIMELINE_CLEANUP = true;
          TIMELINE_CREATE = true;
        };
      };
    };
  };
}

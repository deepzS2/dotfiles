{self, ...}: {
  flake.modules.nixos.omi = {pkgs, ...}: let
    window-manager = "mango";
    shell = pkgs.nushell;
    homeConfig = self.lib.hjemFactory {
      inherit window-manager shell;

      name = "deepz";
      isNormalUser = true;
      description = "Alan";
      extraGroups = ["networkmanager" "wheel" "audio" "docker"];
      host = "omi";
    };
  in
    {
      inherit window-manager;

      imports = with self.modules.nixos; [
        amd
        fhs
        virtualisation
        niri
        mango
        gaming
        sync
        xdg-portal
        obs
      ];

      bootloader = {
        withSecure = false;
        withWindows = false;
      };

      # BTRFS
      environment = {
        systemPackages = [pkgs.btdu pkgs.btrfs-assistant pkgs.timeshift];
        shells = [shell];
      };
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

      system.stateVersion = "25.05";
    }
    // homeConfig;
}

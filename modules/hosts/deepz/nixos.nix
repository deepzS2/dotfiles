{self, ...}: {
  flake.modules.nixos.deepz = {pkgs, ...}: let
    window-manager = "mango";
    shell = pkgs.nushell;
    homeConfig = self.lib.homeFactory {
      inherit window-manager shell;

      name = "deepz";
      isNormalUser = true;
      description = "Alan";
      extraGroups = ["networkmanager" "wheel" "audio" "docker"];
    };
  in
    {
      inherit window-manager;

      imports = with self.modules.nixos; [
        nvidia
        fhs
        virtualisation
        niri
        mango
        hyprland
        gaming
        sync
      ];

      bootloader = {
        withSecure = true;
        withWindows = true;
      };

      # GTX 1650 Turing
      hardware.nvidia.open = true;

      # BTRFS
      environment = {
        systemPackages = [pkgs.btdu pkgs.btrfs-assistant pkgs.timeshift];
        shells = [shell];
      };
      services.btrfs.autoScrub = {
        enable = true;
        fileSystems = ["/"];
      };
      services.snapper = {
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

      system.stateVersion = "25.05";
    }
    // homeConfig;
}

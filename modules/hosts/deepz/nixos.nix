{self, ...}: {
  flake.modules.nixos.deepz = {pkgs, ...}: let
    window-manager = "mango";
    homeConfig = self.lib.homeFactory {
      inherit window-manager;

      name = "deepz";
      isNormalUser = true;
      description = "Alan";
      extraGroups = ["networkmanager" "wheel" "audio" "docker"];
      shell = pkgs.nushell;
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
      environment.systemPackages = [pkgs.btdu pkgs.btrfs-assistant];

      system.stateVersion = "25.05";
    }
    // homeConfig;
}

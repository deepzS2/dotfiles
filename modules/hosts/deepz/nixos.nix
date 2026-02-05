{
  inputs,
  self,
  ...
}: let
  user = "deepz";
  wm = "niri";
in {
  flake.modules.nixos.deepz = {pkgs, ...}: {
    imports =
      [
        inputs.niri.nixosModules.niri
      ]
      ++ (with self.modules.nixos; [
        nvidia
        fhs
        virtualisation
        niri
      ]);

    bootloader = {
      withSecure = true;
      withWindows = true;
    };

    settings.wm = wm;

    users.users.deepz = {
      isNormalUser = true;
      description = "Alan";
      extraGroups = ["networkmanager" "wheel" "audio" "docker"];
      shell = pkgs.nushell;
    };

    home-manager = self.lib.homeFactory user wm;

    system.stateVersion = "25.05";
  };
}

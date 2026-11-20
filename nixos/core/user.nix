{
  lib,
  pkgs,
  config,
  self,
  inputs,
  ...
}: let
  hjemCore = import "${self}/lib/import-tree.nix" lib "${self}/hjem/core";
in {
  users.users.deepz = {
    isNormalUser = true;
    description = "Alan";
    extraGroups = ["networkmanager" "wheel" "audio" "docker"];
    shell = pkgs.nushell;
  };

  environment.shells = [pkgs.nushell];

  hjem = {
    clobberByDefault = true;
    specialArgs = {inherit inputs self;};
    extraModules = hjemCore;

    users.deepz = {
      directory = "/home/deepz";
      window-manager = lib.mkDefault config.window-manager;
    };
  };
}

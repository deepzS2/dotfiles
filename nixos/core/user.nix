{
  lib,
  pkgs,
  config,
  self,
  inputs,
  ...
}: let
  hjemCore = let
    isModule = p: let r = lib.removePrefix "${self}/hjem/core" (toString p); in lib.hasSuffix ".nix" r && !lib.hasInfix "/_" r;
  in
    map import (lib.filter isModule (lib.filesystem.listFilesRecursive "${self}/hjem/core"));
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

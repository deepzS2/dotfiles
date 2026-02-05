{inputs, ...}: let
  home-manager-config = {
    home-manager = {
      backupFileExtension = "bkp";
      overwriteBackup = true;
    };
  };
in {
  flake.modules.nixos.core = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      home-manager-config
    ];
  };

  flake.modules.homeManager.core = {config, ...}: let
    cfg = config.settings;
  in {
    home = {
      homeDirectory = "/home/${cfg.user}";
      username = cfg.user;
    };

    programs.home-manager.enable = true;
  };
}

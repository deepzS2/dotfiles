{
  inputs,
  self,
  lib,
  ...
}: {
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = {};
  };

  config.flake.lib = {
    mkNixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          self.modules.nixos.core
          inputs.home-manager.nixosModules.home-manager
          self.modules.nixos.${name}
          {nixpkgs.hostPlatform = lib.mkDefault system;}
        ];
      };
    };

    homeFactory = user: {
      users.users.${user.name} = {
        inherit (user) isNormalUser description extraGroups shell;
      };

      home-manager = {
        backupFileExtension = "bkp";
        overwriteBackup = true;
        users.${user.name} = {
          imports = [
            self.modules.homeManager.core
            self.modules.homeManager.base
            self.modules.homeManager.${user.name}
          ];

          home = {
            homeDirectory = "/home/${user.name}";
            username = user.name;
          };

          programs.home-manager.enable = true;

          inherit (user) window-manager;
        };
      };
    };

    mkHomeManager = system: name: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [
          self.modules.homeManager.core
          self.modules.homeManager.base
          self.modules.homeManager.${name}
          {nixpkgs.config.allowUnfree = true;}
        ];
      };
    };
  };
}

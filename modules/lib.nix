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
          inputs.hjem.nixosModules.default
          self.modules.nixos.${name}
          {nixpkgs.hostPlatform = lib.mkDefault system;}
        ];
      };
    };

    hjemFactory = user: {
      users.users.${user.name} = {
        inherit (user) isNormalUser description extraGroups shell;
      };

      hjem.users.${user.name} = {
        imports = [
          self.modules.hjem.core
          self.modules.hjem.base
          self.modules.hjem.${user.name}
        ];

        directory = "/home/${user.name}";

        inherit (user) window-manager;
      };
    };
  };
}

{inputs, ...}: {
  flake.modules.nixos.secrets = {...}: {
    programs.gnupg.agent = {
      enable = true;
    };
  };

  flake.modules.homeManager.secrets = {
    config,
    pkgs,
    ...
  }: {
    imports = [inputs.nix-secrets.homeModules.default];

    home.packages = [pkgs.oama pkgs.offlineimap];
    age.identityPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
  };
}

{inputs, ...}: {
  flake.modules.homeManager.secrets = {config, ...}: {
    imports = [inputs.nix-secrets.homeModules.default];

    age.identityPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
  };
}

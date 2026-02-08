{inputs, ...}: {
  flake.modules.homeManager.secrets = {pkgs, ...}: {
    home.packages = [inputs.sheez.packages.${pkgs.stdenv.hostPlatform.system}.default];
  };
}

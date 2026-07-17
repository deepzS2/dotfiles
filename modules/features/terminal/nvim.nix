{inputs, ...}: {
  flake.modules.homeManager.nvim = {pkgs, ...}: {
    home.packages = [inputs.nvimz.packages.${pkgs.stdenv.hostPlatform.system}.default];
  };
}

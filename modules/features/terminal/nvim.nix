{inputs, ...}: {
  flake.modules.hjem.nvim = {pkgs, ...}: {
    config.packages = [inputs.nvimz.packages.${pkgs.stdenv.hostPlatform.system}.default];
  };
}

{
  inputs,
  pkgs,
  ...
}: {
  packages = [inputs.nvimz.packages.${pkgs.stdenv.hostPlatform.system}.default];
}

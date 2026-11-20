{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.mangowm.nixosModules.mango];

  window-manager = lib.mkDefault "mango";

  programs.mango = {
    enable = true;
    addLoginEntry = true;
  };

  programs.dconf.enable = true;
}

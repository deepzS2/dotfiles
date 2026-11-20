{
  flake.modules.nixos.nh = {...}: {
    programs.nh = {
      enable = true;

      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep 3 --keep-since 4d --no-gcroots";
      };
    };
  };

  flake.modules.hjem.nh = {pkgs, ...}: {
    config.packages = [pkgs.nh];
  };
}

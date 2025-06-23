{
  lib,
  config,
  ...
}: let
  cfg = config.applications.obs;
in {
  options = {
    applications.obs.enable = lib.mkEnableOption "OBS";
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
    };
  };
}

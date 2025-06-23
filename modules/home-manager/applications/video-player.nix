{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.applications.obs;
in {
  options = {
    applications.video-player.enable = lib.mkEnableOption "Video Player";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.vlc];
  };
}

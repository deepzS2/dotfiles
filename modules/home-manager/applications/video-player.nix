# Video player (VLC) configuration module for Home Manager
# Exported as flake.modules.homeManager.video-player
{
  flake.modules.homeManager.video-player = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.applications.video-player;
  in {
    options = {
      applications.video-player.enable = lib.mkEnableOption "Video Player";
    };

    config = lib.mkIf cfg.enable {
      home.packages = [pkgs.vlc];
    };
  };
}

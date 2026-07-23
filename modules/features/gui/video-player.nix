{
  flake.modules.hjem.video-player = {pkgs, ...}: {
    config.packages = [pkgs.vlc];
  };
}

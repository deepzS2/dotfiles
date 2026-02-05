{
  flake.modules.homeManager.video-player = {pkgs, ...}: {
    home.packages = [pkgs.vlc];
  };
}

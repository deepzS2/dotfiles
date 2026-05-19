{
  flake.modules.homeManager.music = {
    pkgs,
    config,
    ...
  }: {
    home.packages = [pkgs.yt-dlp pkgs.ffmpeg];

    services.mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/music";
      extraConfig = ''
        bind_to_address "/tmp/mpd_socket"

        audio_output {
          type "pipewire"
          name "My Pipewire"
        }
      '';
    };

    programs.rmpc = {
      enable = true;
      config = ''
        (
          address: "/tmp/mpd_socket",
          cache_dir: Some("/tmp/rmpc/cache")
        )
      '';
    };
  };
}

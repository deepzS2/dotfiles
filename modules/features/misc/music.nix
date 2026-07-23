{
  flake.modules.hjem.music = {
    pkgs,
    config,
    ...
  }: {
    config = {
      packages = [pkgs.yt-dlp pkgs.ffmpeg pkgs.mpd pkgs.rmpc];

      xdg.config.files."mpd/mpd.conf".text = ''
        music_directory "${config.directory}/music"
        bind_to_address "/tmp/mpd_socket"

        audio_output {
          type "pipewire"
          name "My Pipewire"
        }
      '';

      xdg.config.files."rmpc/config.toml".text = ''
        address = "/tmp/mpd_socket"
        cache_dir = "/tmp/rmpc/cache"
      '';
    };
  };
}

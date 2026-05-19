{
  flake.modules.homeManager.scripts = {
    pkgs,
    config,
    ...
  }: let
    musicDir = config.services.mpd.musicDirectory;
  in {
    home.packages = [
      (
        pkgs.writeShellApplication {
          name = "yt";

          runtimeInputs = [pkgs.yt-dlp pkgs.ffmpeg pkgs.coreutils pkgs.gnugrep pkgs.gawk pkgs.util-linux];

          text = ''
            set -euo pipefail

            MUSIC_DIR="${musicDir}"

            print_usage() {
              cat << 'EOF'
            Usage: yt <command> <url>

            Commands:
              song <youtube_music_url>    Download a single song to ~/music/<artist>/<title>.mp3
              playlist <playlist_url>     Download all songs from a playlist to ~/music/<artist>/<title>.mp3

            Options:
              -h, --help                  Show this help message
            EOF
            }

            is_playlist_url() {
              local url="$1"

              if echo "$url" | grep -qE '[?&]list='; then
                return 0
              fi

              return 1
            }

            download_song() {
              local url="$1"
              local output_dir="$2"

              # Validate that this is NOT a playlist URL
              if is_playlist_url "$url"; then
                echo "Error: This URL appears to be a playlist."
                echo "Use 'yt playlist <url>' instead to download all tracks from a playlist."
                exit 1
              fi

              echo "Downloading song..."
              echo "Output directory: $output_dir"

              # Create output directory
              mkdir -p "$output_dir"

              # Download with metadata extraction
              yt-dlp \
                --quiet \
                --no-warnings \
                --extract-audio \
                --audio-format mp3 \
                --audio-quality 0 \
                --embed-metadata \
                --embed-thumbnail \
                --convert-thumbnails jpg \
                --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
                --output "$output_dir/%(artist,uploader)s/%(title)s.%(ext)s" \
                --no-overwrites \
                "$url"

              echo "Download complete!"
            }

            download_playlist() {
              local url="$1"

              # Validate that this IS a playlist URL
              if ! is_playlist_url "$url"; then
                echo "Error: This URL does not appear to be a playlist."
                echo "Use 'yt song <url>' instead to download a single song."
                exit 1
              fi

              echo "Fetching playlist information..."

              # Get playlist title
              local playlist_title
              playlist_title=$(yt-dlp --quiet --no-warnings --print "%(playlist_title)s" "$url" 2>/dev/null || echo "")

              if [ -z "$playlist_title" ] || [ "$playlist_title" = "NA" ]; then
                echo "Error: Could not fetch playlist title. Make sure the URL is valid and the playlist is accessible."
                exit 1
              fi

              echo "Playlist: $playlist_title"
              echo "Downloading playlist tracks to: $MUSIC_DIR"

              # Create output directory
              mkdir -p "$MUSIC_DIR"

              echo "Downloading playlist tracks..."

              # Download playlist using same structure as single songs
              yt-dlp \
                --quiet \
                --no-warnings \
                --extract-audio \
                --audio-format mp3 \
                --audio-quality 0 \
                --embed-metadata \
                --embed-thumbnail \
                --convert-thumbnails jpg \
                --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
                --output "$MUSIC_DIR/%(artist,uploader)s/%(title)s.%(ext)s" \
                --no-overwrites \
                "$url"

              echo "Playlist download complete!"
              echo "Files saved to: $MUSIC_DIR"
            }

            # Parse command line arguments
            if [ $# -eq 0 ]; then
              print_usage
              exit 1
            fi

            case "$1" in
              -h|--help)
                print_usage
                exit 0
                ;;
              song)
                if [ $# -lt 2 ]; then
                  echo "Error: Missing URL for song command"
                  print_usage
                  exit 1
                fi
                download_song "$2" "$MUSIC_DIR"
                ;;
              playlist)
                if [ $# -lt 2 ]; then
                  echo "Error: Missing URL for playlist command"
                  print_usage
                  exit 1
                fi
                download_playlist "$2"
                ;;
              *)
                echo "Error: Unknown command '$1'"
                print_usage
                exit 1
                ;;
            esac
          '';
        }
      )
    ];
  };
}

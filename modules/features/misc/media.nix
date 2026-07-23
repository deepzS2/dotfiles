{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.hjem.media = {
    config.files.".theme/sounds" = {
      source = "${directories.media}/sounds";
    };
    config.files.".theme/wallpapers" = {
      source = "${directories.media}/wallpapers";
    };
  };
}

{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.homeManager.scripts = {
    home.file.".theme/sounds" = {
      source = "${directories.media}/sounds";
      recursive = true;
    };

    home.file.".theme/wallpapers" = {
      source = "${directories.media}/wallpapers";
      recursive = true;
    };
  };
}

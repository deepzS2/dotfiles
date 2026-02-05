{config, ...}: let
  inherit (config.flake) assets;
in {
  flake.modules.homeManager.scripts = {
    home.file.".theme/sounds" = {
      source = "${assets.media}/sounds";
      recursive = true;
    };

    home.file.".theme/wallpapers" = {
      source = "${assets.media}/wallpapers";
      recursive = true;
    };
  };
}

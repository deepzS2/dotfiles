{
  flake.modules.homeManager.scripts = _: {
    home.file.".theme/sounds" = {
      source = ../../../../config/theme/sounds;
      recursive = true;
    };

    home.file.".theme/wallpapers" = {
      source = ../../../../config/theme/wallpapers;
      recursive = true;
    };
  };
}

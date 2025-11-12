{self, ...}: {
  flake.modules.homeManager.scripts = _: {
    home.file.".theme/sounds" = {
      source = "${self}/config/theme/sounds";
      recursive = true;
    };

    home.file.".theme/wallpapers" = {
      source = "${self}/config/theme/wallpapers";
      recursive = true;
    };
  };
}

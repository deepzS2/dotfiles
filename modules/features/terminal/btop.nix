{
  flake.modules.homeManager.btop = _: {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "matugen";
      };
    };
  };
}

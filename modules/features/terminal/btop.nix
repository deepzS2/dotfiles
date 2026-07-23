{
  flake.modules.hjem.btop = {pkgs, ...}: {
    config = {
      packages = [pkgs.btop];
      xdg.config.files."btop/btop.conf".text = ''
        color_theme = "matugen"
      '';
    };
  };
}

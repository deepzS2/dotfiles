{pkgs, ...}: {
  packages = [pkgs.btop];

  xdg.config.files."btop/btop.conf".text = ''
    color_theme = "matugen"
  '';
}

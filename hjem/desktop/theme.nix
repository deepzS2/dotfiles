{
  pkgs,
  inputs,
  self,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  packages = [
    inputs.matugen.packages.${system}.default
    self.packages.${system}.kanagawa-gtk-theme
    pkgs.gowall
    pkgs.awww
    pkgs.bibata-cursors
    pkgs.kanagawa-icon-theme
  ];

  xdg.config.files = {
    "matugen".source = "${self}/config/matugen";

    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name = Kanagawa-Dark
      gtk-icon-theme-name = Kanagawa
      gtk-application-prefer-dark-theme = 1
      gtk-cursor-theme-name = Bibata-Modern-Classic
      gtk-cursor-theme-size = 24
    '';

    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name = Kanagawa-Dark
      gtk-icon-theme-name = Kanagawa
      gtk-application-prefer-dark-theme = 1
      gtk-cursor-theme-name = Bibata-Modern-Classic
      gtk-cursor-theme-size = 24
    '';

    "icons/default/index.theme".text = ''
      [Icon Theme]
      Name = Default
      Comment = Default Cursor Theme
      Inherits = Bibata-Modern-Classic
    '';
  };

  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };
}

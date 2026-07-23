{
  self,
  inputs,
  ...
}: let
  inherit (self) directories;
in {
  flake.modules.hjem.theme = {pkgs, ...}: {
    config = {
      packages = [
        inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
        self.packages.${pkgs.stdenv.hostPlatform.system}.kanagawa-gtk-theme
        pkgs.gowall
        pkgs.awww
        pkgs.bibata-cursors
        pkgs.kanagawa-icon-theme
      ];

      xdg.config.files."matugen".source = "${directories.config}/matugen";

      xdg.config.files."gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name = Kanagawa-Dark
        gtk-icon-theme-name = Kanagawa
        gtk-application-prefer-dark-theme = 1
        gtk-cursor-theme-name = Bibata-Modern-Classic
        gtk-cursor-theme-size = 24
      '';

      xdg.config.files."gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name = Kanagawa-Dark
        gtk-icon-theme-name = Kanagawa
        gtk-application-prefer-dark-theme = 1
        gtk-cursor-theme-name = Bibata-Modern-Classic
        gtk-cursor-theme-size = 24
      '';

      xdg.config.files."icons/default/index.theme".text = ''
        [Icon Theme]
        Name = Default
        Comment = Default Cursor Theme
        Inherits = Bibata-Modern-Classic
      '';

      environment.sessionVariables = {
        XCURSOR_THEME = "Bibata-Modern-Classic";
        XCURSOR_SIZE = "24";
      };
    };
  };
}

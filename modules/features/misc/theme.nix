{
  self,
  inputs,
  ...
}: let
  inherit (self) directories;
in {
  flake.modules.homeManager.theme = {pkgs, ...}: {
    home.packages = [
      inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.gowall # Convert image to colorscheme
      pkgs.awww
    ];

    home.file.".config/matugen" = {
      source = "${directories.config}/matugen";
      recursive = true;
    };

    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    gtk = {
      enable = true;
      colorScheme = "dark";
      gtk4.theme = null;
      theme = {
        name = "Kanagawa-Dark";
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.kanagawa-gtk-theme;
      };
      iconTheme = {
        name = "Kanagawa";
        package = pkgs.kanagawa-icon-theme;
      };
    };
  };
}

{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) assets;
in {
  flake.modules.homeManager.theme = {pkgs, ...}: {
    home.packages = [
      inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.gowall # Convert image to colorscheme
      pkgs.swww
      pkgs.bibata-cursors
    ];

    home.file.".config/matugen" = {
      source = "${assets.path}/matugen";
      recursive = true;
    };

    gtk = let
      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
    in {
      enable = true;
      colorScheme = "dark";
      inherit theme;
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };

      gtk3 = {inherit theme;};
      gtk4 = {inherit theme;};
    };
  };
}

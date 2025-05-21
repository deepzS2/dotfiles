{ pkgs, ... }:
  {
    # Install fonts
    fonts = {
      packages = [
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.jetbrains-mono
        pkgs.roboto
        pkgs.openmoji-color
      ];

      fontconfig = {
        enable = true;
        hinting.autohint = true;
        defaultFonts = {
          emoji = [ "OpenMoji Color" ];
        };
      };
    };
  }
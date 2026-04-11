{
  flake.modules.nixos.core = {pkgs, ...}: {
    # Install fonts
    fonts = {
      packages = [
        pkgs.atkinson-hyperlegible-next
        pkgs.nerd-fonts.iosevka
        pkgs.nerd-fonts.atkynson-mono
        pkgs.nerd-fonts.iosevka-term
        pkgs.roboto
        pkgs.icomoon-feather
        pkgs.openmoji-color
      ];

      fontconfig = {
        enable = true;
        hinting.autohint = true;
        defaultFonts = {
          emoji = ["OpenMoji Color"];
          monospace = ["Iosevka Nerd Font Mono"];
          sansSerif = ["Iosevka Nerd Font Propo"];
        };
      };
    };
  };
}

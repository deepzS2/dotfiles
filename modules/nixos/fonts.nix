# Fonts configuration module for NixOS
# Exported as flake.modules.nixosModules.fonts
{
  flake.modules.nixosModules.fonts = {pkgs, ...}: {
    # Install fonts
    fonts = {
      packages = [
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.iosevka
        pkgs.jetbrains-mono
        pkgs.roboto
        pkgs.icomoon-feather
        pkgs.openmoji-color
      ];

      fontconfig = {
        enable = true;
        hinting.autohint = true;
        defaultFonts = {
          emoji = ["OpenMoji Color"];
        };
      };
    };
  };
}

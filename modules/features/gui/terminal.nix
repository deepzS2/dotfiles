{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.homeManager.terminal = {pkgs, ...}: {
    home.file.".config/ghostty" = {
      source = "${directories.config}/ghostty";
      recursive = true;
    };

    programs.ghostty.enable = true;
  };
}

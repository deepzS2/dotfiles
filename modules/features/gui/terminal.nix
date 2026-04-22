{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.homeManager.terminal = {
    home.file.".config/ghostty" = {
      source = "${directories.config}/ghostty";
      recursive = true;
    };

    programs.ghostty = {
      enable = true;
      systemd.enable = true;
    };
  };
}

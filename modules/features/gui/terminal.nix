{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.homeManager.terminal = {pkgs, ...}: {
    home.packages = [pkgs.kitty];

    home.file.".config/kitty/kitty.conf" = {
      source = "${directories.config}/kitty.conf";
      onChange = "${pkgs.procps}/bin/pkill -USR1 -u $USER kitty || true";
    };
  };
}

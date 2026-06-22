{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.homeManager.terminal = {pkgs, ...}: {
    home.packages = [pkgs.foot];

    home.file.".config/foot/foot.ini".source = "${directories.config}/foot.ini";
  };
}

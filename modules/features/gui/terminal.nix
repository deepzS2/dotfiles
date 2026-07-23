{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.hjem.terminal = {pkgs, ...}: {
    config = {
      packages = [pkgs.foot];
      xdg.config.files."foot/foot.ini".source = "${directories.config}/foot.ini";
    };
  };
}

{self, ...}: {
  flake.modules.hjem.dmenu = {pkgs, ...}: let
    mkRasiFiles = files:
      builtins.listToAttrs (map (file: {
          name = "rofi/${file}";
          value = {
            source = "${self.directories.config}/rofi/${file}";
          };
        })
        files);
  in {
    config = {
      packages = [
        pkgs.rofi
        pkgs.wmctrl
      ];

      xdg.config.files = mkRasiFiles [
        "cliphistory.rasi"
        "launcher.rasi"
        "theme-switcher.rasi"
        "wallpaper-switcher.rasi"
        "wifimenu-password.rasi"
        "wifimenu.rasi"
      ];
    };
  };
}

{
  pkgs,
  self,
  ...
}: {
  packages = [
    pkgs.rofi
    pkgs.wmctrl
  ];

  xdg.config.files = builtins.listToAttrs (map (file: {
      name = "rofi/${file}";
      value = {
        source = "${self}/config/rofi/${file}";
      };
    })
    [
      "cliphistory.rasi"
      "launcher.rasi"
      "theme-switcher.rasi"
      "wallpaper-switcher.rasi"
      "wifimenu-password.rasi"
      "wifimenu.rasi"
    ]);
}

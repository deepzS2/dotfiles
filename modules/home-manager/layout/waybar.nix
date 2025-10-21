{
  flake.modules.homeManager.waybar = {
    pkgs,
    config,
    ...
  }: let
    waybarUserConfigDir = "${config.xdg.configHome}/waybar";
    waybarConfigJson = ../../../config/waybar/config.jsonc;
  in {
    home.packages = [
      pkgs.networkmanagerapplet
      pkgs.pavucontrol
    ];

    services.blueman-applet.enable = true;

    programs.waybar = {
      enable = true;
      style = builtins.readFile ../../../config/waybar/style.css;
    };

    home.file."${waybarUserConfigDir}/config.jsonc".source = waybarConfigJson;
  };
}

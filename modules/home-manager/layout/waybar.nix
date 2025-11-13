{config, ...}: let
  # We inherit assets here so the homeManager config don't overwrite it.
  inherit (config.flake) assets;
in {
  flake.modules.homeManager.waybar = {
    pkgs,
    config,
    ...
  }: let
    waybarUserConfigDir = "${config.xdg.configHome}/waybar";
    waybarConfigJson = "${assets.path}/waybar/config.jsonc";
  in {
    home.packages = [
      pkgs.networkmanagerapplet
      pkgs.pavucontrol
    ];

    services.blueman-applet.enable = true;

    programs.waybar = {
      enable = true;
      style = builtins.readFile "${assets.path}/waybar/style.css";
    };

    home.file."${waybarUserConfigDir}/config.jsonc".source = waybarConfigJson;
  };
}

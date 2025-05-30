{
  lib,
  config,
  ...
}: let
  cfg = config.applications.discord;
in {
  options = {
    applications.discord.enable = lib.mkEnableOption "Discord";
  };

  config = lib.mkIf cfg.enable {
    programs.vesktop = {
      enable = true;
    };
  };
}

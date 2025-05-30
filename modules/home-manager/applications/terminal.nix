{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.applications.terminal;
in {
  options = {
    applications.terminal.enable = lib.mkEnableOption "Ghostty terminal";
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        # theme = /home/deepz/.cache/wal/ghostty.conf
        background-opacity = 0.8;
        font-family = "JetBrainsMono Nerd Font Mono";
        font-size = 14;
        window-padding-x = 12;
        command = "${pkgs.nushell}/bin/nu --login --interactive";
        confirm-close-surface = false;
      };
    };
  };
}

{
  lib,
  config,
  ...
}: let
  cfg = config.shell.btop;
in {
  options = {
    shell.btop.enable = lib.mkEnableOption "Btop++ resource monitor";
  };

  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;
    };
  };
}

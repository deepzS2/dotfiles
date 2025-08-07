{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.shell.ai;
in {
  options = {
    shell.ai.enable = lib.mkEnableOption "AI tools";
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."google/gemini_key" = {};

    programs.nushell.extraEnv = lib.mkAfter ''
      $env.GOOGLE_API_KEY = (open ${config.sops.secrets."google/gemini_key".path})
    '';

    home.packages = [
      pkgs.gemini-cli
    ];
  };
}

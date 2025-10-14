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
    programs.nushell.extraEnv = lib.mkAfter ''
      $env.GOOGLE_API_KEY = (bash -c "cat ${config.age.secrets.gemini_key.path}")
    '';

    programs.opencode = {
      enable = true;
      settings = {
        model = "github-copilot/gpt-5";
        theme = "kanagawa";
        autoupdate = true;
      };
    };

    home.packages = [
      pkgs.gemini-cli
    ];
  };
}

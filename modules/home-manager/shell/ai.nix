{
  flake.modules.homeManager.ai = {
    pkgs,
    config,
    ...
  }: {
    programs.nushell.extraEnv = ''
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

    home.packages = [pkgs.gemini-cli];
  };
}

# Browser (Zen) configuration module for Home Manager
# Exported as flake.modules.homeManager.browser
{
  flake.modules.homeManager.browser = {
    lib,
    config,
    ...
  }: let
    cfg = config.applications.browser;
  in {
    options = {
      applications.browser.enable = lib.mkEnableOption "Zen browser";
    };

    config = lib.mkIf cfg.enable {
      # home.packages = [
      # inputs.zen-browser.packages."${system}".default
      # ];

      programs.zen-browser = {
        enable = true;
        policies = {
          DisableAppUpdate = true;
          DisableTelemetry = true;
          # find more options here: https://mozilla.github.io/policy-templates/
        };
      };
    };
  };
}

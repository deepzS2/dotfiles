{ lib, config, ... }:
  let 
    cfg = config.browser;
  in {
    options = {
      browser.enable = lib.mkEnableOption "Zen browser";
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
  }
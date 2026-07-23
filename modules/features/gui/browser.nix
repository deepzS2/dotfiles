{inputs, ...}: {
  flake.modules.hjem.browser = {pkgs, ...}: {
    config = let
      zenName = "beta";

      defaultAssociations = {
        "application/x-extension-shtml" = "zen-${zenName}.desktop";
        "application/x-extension-xhtml" = "zen-${zenName}.desktop";
        "application/x-extension-html" = "zen-${zenName}.desktop";
        "application/x-extension-xht" = "zen-${zenName}.desktop";
        "application/x-extension-htm" = "zen-${zenName}.desktop";
        "x-scheme-handler/unknown" = "zen-${zenName}.desktop";
        "x-scheme-handler/mailto" = "zen-${zenName}.desktop";
        "x-scheme-handler/chrome" = "zen-${zenName}.desktop";
        "x-scheme-handler/about" = "zen-${zenName}.desktop";
        "x-scheme-handler/https" = "zen-${zenName}.desktop";
        "x-scheme-handler/http" = "zen-${zenName}.desktop";
        "application/xhtml+xml" = "zen-${zenName}.desktop";
        "application/json" = "zen-${zenName}.desktop";
        "text/plain" = "zen-${zenName}.desktop";
        "text/html" = "zen-${zenName}.desktop";
      };

      mimeappsIni = (pkgs.formats.ini {listToValue = ";";}).generate "mimeapps.list" {
        "Added Associations" = defaultAssociations;
        "Default Applications" = defaultAssociations;
      };
    in {
      packages = [
        (inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
          nativeMessagingHosts = [pkgs.firefoxpwa];
          extraPolicies = {
            AutofillAddressEnabled = true;
            AutofillCreditCardEnabled = false;
            DisableAppUpdate = true;
            DisableFeedbackCommands = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            ExtensionSettings = {
              "addon@darkreader.org" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
                installation_mode = "force_installed";
              };
              "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
                installation_mode = "force_installed";
              };
              "nordpassStandalone@nordsecurity.com" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/nordpass-password-management/latest.xpi";
                installation_mode = "force_installed";
              };
            };
          };
        })
      ];

      xdg.config.files."mimeapps.list".source = mimeappsIni;
      environment.sessionVariables.BROWSER = "zen-${zenName}";
    };
  };
}

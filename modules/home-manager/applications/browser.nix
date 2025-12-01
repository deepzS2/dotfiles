{
  flake.modules.homeManager.browser = {pkgs, ...}: {
    programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = [pkgs.firefoxpwa];
      policies = let
        mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
          installation_mode = "force_installed";
        });
      in {
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
        ExtensionSettings = mkExtensionSettings {
          "addon@darkreader.org" = "darkreader";
          "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = "refined-github-";
          "nordpassStandalone@nordsecurity.com" = "nordpass-password-management";
        };
      };

      profiles.default = {
        isDefault = true;
        settings = {
          "zen.tabs.show-newtab-vertical" = true;
          "zen.view.show-newtab-button-top" = true;
          "zen.urlbar.behavior" = "float";
          "zen.view.compact.enable-at-startup" = true;
          "zen.view.compact.hide-toolbar" = false;
          "zen.view.compact.toolbar-flash-popup" = true;
          "zen.view.window.scheme" = 0;
          "zen.welcome-screen.seen" = true;
        };
        search = {
          force = true;
          default = "duckduckgo";
        };
      };
    };
  };
}

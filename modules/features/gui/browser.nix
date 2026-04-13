{inputs, ...}: {
  flake.modules.homeManager.browser = {pkgs, ...}: {
    imports = [
      inputs.zen-browser.homeModules.beta
    ];

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
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
        id = 0;
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
        mods = [
          "72f8f48d-86b9-4487-acea-eb4977b18f21" # Better CtrlTab
          "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
          "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
          "c6813222-6571-4ba6-8faf-58f3343324f6" # Disable Rounded Corners
          "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
          "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
          "79dde383-4fe7-404a-a8e6-9be440022542" # Tidy Popup
          "4c2bec61-7f6c-4e5c-bdc6-c9ad1aba1827" # Vertical Split Tab Groups
        ];
        search = {
          force = true;
          default = "ddg";
        };
        spacesForce = false;
        containersForce = false;
        pinsForce = false;
      };
    };
  };
}

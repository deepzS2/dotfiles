{self, ...}: let
  inherit (self) directories;

  profilesRoot = ".librewolf";
  profileName = "default";
  profilePath = "${profilesRoot}/${profileName}";

  mkExtension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };
in {
  flake.modules.hjem.browser = {pkgs, ...}: {
    config = {
      packages = [
        (pkgs.wrapFirefox pkgs.librewolf-unwrapped {
          inherit (pkgs.librewolf-unwrapped) extraPrefsFiles extraPoliciesFiles;

          nativeMessagingHosts = [pkgs.keepassxc];
          hasMozSystemDirPatch = true;

          extraPrefs = ''
            lockPref("xpinstall.signatures.required", true);

            defaultPref(
              "toolkit.legacyUserProfileCustomizations.stylesheets",
              true
            );
          '';

          extraPolicies = {
            DisableTelemetry = true;
            ExtensionSettings = builtins.listToAttrs [
              (mkExtension "ublock-origin" "uBlock0@raymondhill.net")
              (mkExtension "sidebery" "{3c078156-979c-498b-8990-85f7987dd929}")
              (mkExtension "darkreader" "addon@darkreader.org")
              (mkExtension "firefox-color" "FirefoxColor@mozilla.com")
              (mkExtension "volume-control" "{57e8684d-5ae8-47d6-93c9-f870ef0e40a3}")
              (mkExtension "keepassxc-browser" "keepassxc-browser@keepassxc.org")
            ];

            SearchEngines = {
              Default = "ddg";
              Add = [
                {
                  Name = "nixpkgs packages";
                  URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                  IconURL = "https://wiki.nixos.org/favicon.ico";
                  Alias = "@np";
                }
                {
                  Name = "NixOS options";
                  URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
                  IconURL = "https://wiki.nixos.org/favicon.ico";
                  Alias = "@no";
                }
                {
                  Name = "NixOS Wiki";
                  URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                  IconURL = "https://wiki.nixos.org/favicon.ico";
                  Alias = "@nw";
                }
                {
                  Name = "noogle";
                  URLTemplate = "https://noogle.dev/q?term={searchTerms}";
                  IconURL = "https://noogle.dev/favicon.ico";
                  Alias = "@ng";
                }
              ];
            };
          };
        })
      ];

      files = {
        "${profilesRoot}/profiles.ini" = {
          text = ''
            [General]
            StartWithLastWindow=1

            [Profile0]
            Name=${profileName}
            IsRelative=1
            Path=${profileName}
            Default=1
          '';
          clobber = false;
        };

        "${profilePath}/chrome/userChrome.css".source = "${directories.config}/librewolf/userChrome.css";
      };
    };
  };
}

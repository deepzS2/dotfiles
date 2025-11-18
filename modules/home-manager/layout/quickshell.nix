{
  inputs,
  config,
  ...
}: let
  # We inherit assets here so the homeManager config don't overwrite it.
  inherit (config.flake) assets;
in {
  flake.modules.homeManager.quickshell = {
    pkgs,
    config,
    ...
  }: {
    home.packages = [
      inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.brightnessctl
    ];

    home.file.".config/quickshell" = {
      source = config.lib.file.mkOutOfStoreSymlink "${assets.path}/quickshell";
      recursive = true;
    };

    programs.noctalia-shell = {
      enable = false;
      settings = {
        bar = {
          # density = "compact";
          position = "top";
          showCapsule = true;
          widgets = {
            left = [
              {
                id = "SidePanelToggle";
                useDistroLogo = true;
              }
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "none";
              }
              {
                id = "ActiveWindow";
              }
            ];
            right = [
              {
                formatHorizontal = "HH:mm";
                formatVertical = "HH:mm";
                id = "Clock";
              }
              {
                id = "SystemMonitor";
              }
              {
                id = "Brightness";
                displayMode = "alwaysShow";
              }
              {
                id = "Volume";
                displayMode = "alwaysShow";
              }
              {
                id = "Microphone";
                displayMode = "alwaysShow";
              }
              {
                id = "WiFi";
              }
              {
                id = "Battery";
                displayMode = "alwaysShow";
              }
            ];
          };
        };
        colorSchemes.predefinedScheme = "Monochrome";
        general = {
          avatarImage = "/home/deepz/.dotfiles/config/theme/avatars/me.png";
          radiusRatio = 0.2;
        };
        location = {
          name = "Marseille, France";
        };
      };
    };
  };
}

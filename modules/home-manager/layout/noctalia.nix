{inputs, ...}: {
  flake.modules.homeManager.noctalia = {}: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
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

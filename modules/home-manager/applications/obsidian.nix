{
  flake.modules.homeManager.obsidian = _: {
    # TODO: Everytime I open the Obsidian App it asks for the vault and if I trust the plugin authors
    # Need some configuration to not have that behaviour anymore
    programs.obsidian = {
      enable = true;
    };

    services.syncthing = {
      enable = true;
      tray.enable = true;
      settings.folders = {
        "Obsidian" = {
          path = "~/Obsidian";
        };
      };
    };
  };
}

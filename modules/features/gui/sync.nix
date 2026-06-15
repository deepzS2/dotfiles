{
  flake.modules.nixos.sync = {
    programs.localsend.enable = true;
  };

  flake.modules.homeManager.sync = {
    services.syncthing = {
      enable = true;
      tray.enable = true;
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
    };
  };
}

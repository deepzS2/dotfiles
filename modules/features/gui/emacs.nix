{inputs, ...}: {
  flake.modules.homeManager.emacs = {pkgs, ...}: {
    home.packages = [
      inputs.demacz.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.hledger # Financial notes
    ];

    services.syncthing = {
      enable = true;
      tray.enable = true;
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
    };
  };
}

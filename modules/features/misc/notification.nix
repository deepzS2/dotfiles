{
  flake.modules.homeManager.notification = {config, ...}: {
    services.mako = {
      enable = true;
      extraConfig = "include=${config.home.homeDirectory}/.config/mako/mako-colors";
      settings = {
        sort = "-time";
        layer = "overlay";
        border-size = 2;
        border-radius = 4;
        icons = true;
        width = 400;
        default-timeout = 5000;
        ignore-timeout = true;
        anchor = "top-right";
      };
    };
  };
}

{
  flake.modules.homeManager.notification = _: {
    services.mako = {
      enable = true;
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
        "mode=do-not-disturb".invisible = 1;
      };
    };
  };
}

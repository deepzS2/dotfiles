{lib, ...}: {
  flake.modules.homeManager.options = {
    options.settings.user = lib.mkOption {
      type = lib.types.str;
      description = "Username";
      example = "deepz";
    };
  };
}

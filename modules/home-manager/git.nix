{
  flake.modules.homeManager.git = {
    lib,
    config,
    ...
  }: {
    options.git = {
      userName = lib.mkOption {
        type = lib.types.str;
        default = "deepzS2";
        description = "Git username";
      };
      userEmail = lib.mkOption {
        type = lib.types.str;
        default = "alanr.developer@hotmail.com";
        description = "Git email";
      };
    };

    config = {
      programs.git = {
        enable = true;
        inherit (config.git) userName;
        inherit (config.git) userEmail;
        extraConfig = {
          init.defaultBranch = "main";
          push.followTags = true;
        };
      };
    };
  };
}

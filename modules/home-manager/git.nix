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
      programs.git = let
        inherit (config.git) userName userEmail;
      in {
        enable = true;
        settings = {
          init.defaultBranch = "main";
          push.followTags = true;
          user = {
            name = userName;
            email = userEmail;
          };
        };
      };
    };
  };
}

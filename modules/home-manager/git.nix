{
  flake.modules.homeManager.git = {lib, config, ...}: {
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
        userName = config.git.userName;
        userEmail = config.git.userEmail;
        extraConfig = {
          init.defaultBranch = "main";
          push.followTags = true;
        };
      };
    };
  };
}

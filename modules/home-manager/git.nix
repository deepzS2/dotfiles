{ lib, config, ... }:
  let 
    cfg = config.git;
  in {
    options.git = { 
      enable = lib.mkEnableOption "git";
      userName = lib.mkOption { 
        type = lib.types.str;
        default = "deepzS2";
        description = "The global Git user.name to use.";
      };
      userEmail = lib.mkOption {
        type = lib.types.str;
        default = "alanr.developer@hotmail.com";
        description = "The global Git user.email to use.";
      };
    };

    config = lib.mkIf cfg.enable {
      programs.git = {
        enable = true;
        userName = cfg.userName;
        userEmail = cfg.userEmail;
        extraConfig = {
          init.defaultBranch = "main";
          push.followTags = true;
        };
      };
    };
  }
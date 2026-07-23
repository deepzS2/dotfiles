{
  flake.modules.hjem.git = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (config.git) userName userEmail;

    gitconfigText = ''
      [init]
        defaultBranch = main
      [push]
        followTags = true
      [user]
        name = ${userName}
        email = ${userEmail}
    '';
  in {
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
      packages = [pkgs.git];

      files.".gitconfig".text = gitconfigText;
    };
  };
}

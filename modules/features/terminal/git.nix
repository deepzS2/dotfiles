{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.hjem.git = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (config.git) userName userEmail;
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
      packages = [pkgs.git pkgs.lazygit pkgs.delta];

      files.".gitconfig" = {
        generator = lib.generators.toGitINI;
        value = {
          init.defaultBranch = "main";
          push.followTags = true;
          core.pager = "delta";
          interactive.diffFilter = "delta --color-only";
          merge.conflictStyle = "zdiff3";
          delta = {
            navigate = true;
            dark = true;
          };
          user = {
            name = userName;
            email = userEmail;
          };
        };
      };
      xdg.config.files."lazygit/config.yml".source = "${directories.config}/lazygit.yml";
    };
  };
}

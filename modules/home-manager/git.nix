{
  flake.modules.homeManager.git = {...}: {
    programs.git = {
      enable = true;
      userName = "deepzS2";
      userEmail = "alanr.developer@hotmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        push.followTags = true;
      };
    };
  };
}

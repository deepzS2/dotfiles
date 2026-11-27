{
  programs.nh = {
    enable = true;

    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 3 --keep-since 4d --no-direnv";
    };
  };
}

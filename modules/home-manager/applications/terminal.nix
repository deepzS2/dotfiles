{
  flake.modules.homeManager.terminal = {pkgs, ...}: {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = "Matugen";
        background-opacity = 0.8;
        font-family = "JetBrainsMono Nerd Font Mono";
        font-size = 14;
        window-padding-x = 12;
        window-decoration = "none";
        command = "${pkgs.nushell}/bin/nu --login --interactive";
        confirm-close-surface = false;
      };
    };
  };
}

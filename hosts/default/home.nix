{inputs, ...}: {
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.nixCats.homeModule
    inputs.stylix.homeModules.stylix
    ../../modules/home-manager
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "deepz";
  home.homeDirectory = "/home/deepz";

  git.enable = true;
  development = {
    javascript = {
      runtimes.enable = true;
      package-managers.enable = true;
    };
  };
  programming-languages = {
    go.enable = true;
  };
  applications = {
    browser.enable = true;
    discord.enable = true;
    obs.enable = true;
    terminal.enable = true;
    video-player.enable = true;
  };
  editor = {
    vscode.enable = true;
    nvim.enable = true;
  };
  shell = {
    btop.enable = true;
    fastfetch.enable = true;
    nushell.enable = true;
    prompt.enable = true;
    tmux.enable = true;
  };
  layout = {
    hyprland = {
      enable = true;
      hypridle.enable = true;
      hyprlock.enable = true;
    };
    scripts.enable = true;
    notification.enable = true;
    rofi.enable = true;
    theme.enable = true;
    wallpaper.enable = true;
    waybar.enable = true;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/deepz/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
}

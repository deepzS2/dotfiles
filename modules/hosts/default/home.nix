{
  inputs,
  self,
  ...
}: {
  imports =
    [
      inputs.zen-browser.homeModules.beta
      inputs.nixCats.homeModule
      inputs.stylix.homeModules.stylix
      inputs.agenix.homeManagerModules.default
    ]
    ++ (with self.modules.homeManager; [
      git
      # Applications
      browser
      discord
      obs
      terminal
      video-player
      # Development
      elixir
      go
      javascript
      rust
      # Editor
      vscode
      nvim
      # Shell
      ai
      btop
      fastfetch
      nushell
      prompt
      tmux
      # Layout
      notification
      rofi
      theme
      wallpaper
      waybar
      # Hyprland
      hypridle
      hyprland
      hyprlock
      # Scripts
      script-clipboard
      script-notification
      script-powermenu
      script-startup
      script-wallpaper-cache
      script-wallpaper-load
      script-wallpaper-select
      script-wifimenu
      # Secrets
      nix-helper
      secrets
    ]);

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

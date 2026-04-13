{self, ...}: {
  flake.modules.homeManager.base = {
    imports = with self.modules.homeManager; [
      git
      browser
      emacs
      terminal
      btop
      fastfetch
      nushell
      tmux
      notification
      dmenu
      theme
      scripts
      secrets
      video-player
    ];
  };
}

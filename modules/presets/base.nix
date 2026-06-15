{self, ...}: {
  flake.modules.homeManager.base = {
    imports = with self.modules.homeManager; [
      git
      browser
      emacs
      terminal
      btop
      fastfetch
      file-manager
      nushell
      tmux
      notification
      dmenu
      theme
      scripts
      secrets
      sync
      video-player
    ];
  };
}

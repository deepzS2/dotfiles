{self, ...}: {
  flake.modules.hjem.base = {
    imports = with self.modules.hjem; [
      git
      browser
      emacs
      terminal
      btop
      file-manager
      nushell
      tmux
      dmenu
      theme
      scripts
      media
      secrets
      sync
      video-player
    ];
  };
}

{self, ...}: {
  flake.modules.hjem.omi = {...}: {
    imports = with self.modules.hjem; [
      discord
      obs
      elixir
      go
      javascript
      rust
      vscode
      nvim
      ai
      nix-search
      idle
      niri
      mango
      dev
      nh
      scripts-extras
      music
    ];

    monitors = [
      {
        name = "DP-2";
        width = 1920;
        height = 1080;
        refresh-rate = 165.0;
        scale = 1.0;
        x = 0;
        y = 0;
        primary = true;
      }
      {
        name = "HDMI-A-1";
        width = 1920;
        height = 1080;
        refresh-rate = 75.0;
        scale = 1.0;
        x = -1920;
        y = 0;
        primary = false;
      }
    ];
  };
}

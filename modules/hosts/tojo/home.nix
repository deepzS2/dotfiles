{self, ...}: {
  flake.modules.hjem.tojo = {...}: {
    imports = with self.modules.hjem; [
      discord
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
        name = "eDP-1";
        width = 1920;
        height = 1080;
        refresh-rate = 144.0;
        scale = 1.0;
        x = 0;
        y = 0;
        primary = true;
      }
    ];
  };
}

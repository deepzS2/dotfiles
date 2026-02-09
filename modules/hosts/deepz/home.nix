{self, ...}: {
  flake.modules.homeManager.deepz = {...}: {
    imports = with self.modules.homeManager; [
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
      hyprland
      nh
      music
    ];

    settings.monitors = [
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

    home.stateVersion = "25.11";
  };
}

{
  config,
  inputs,
  ...
}: {
  flake.modules.homeManager.deepz = {
    imports =
      [
        inputs.zen-browser.homeModules.beta
        # inputs.niri.homeModules.niri
        inputs.niri.homeModules.stylix
        inputs.nixCats.homeModule
        inputs.stylix.homeModules.stylix
        inputs.noctalia.homeModules.default
      ]
      ++ (with config.flake.modules.homeManager; [
        options
        git
        # Applications
        browser
        discord
        obs
        obsidian
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
        nix-search
        nushell
        prompt
        tmux
        # Layout
        bar
        # noctalia
        notification
        rofi
        theme
        wallpaper
        # Hyprland
        hypridle
        hyprland
        niri
        hyprlock
        # Scripts
        scripts
        # Secrets
        nix
        nix-helper
        secrets
      ]);

    home = {
      homeDirectory = "/home/deepz";
      username = "deepz";
      stateVersion = "25.05";
    };

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

    programs.home-manager.enable = true;
  };
}

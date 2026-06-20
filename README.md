<h1 align="center">deepzS2's NixOS Dotfiles</h1>

<p align="center">
  <a href="https://builtwithnix.org">
    <img src="https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a" alt="Built with Nix">
  </a>
</p>

My NixOS config using [flake-parts](https://flake.parts/). Modules auto-register via the [Dendritic Pattern](https://github.com/mightyiam/dendritic).

> **Note**: This is my development environment, not my primary system.

## Highlights

- **Declarative**: NixOS and Home Manager configs
- **Self-Registering Modules**: Modules register themselves automatically
- **Merged Core Modules**: Shared config in `modules/core/`
- **Feature-Based Organization**: Organized by function: terminal, GUI, dev, window manager
- **Development-ready**: Dev shell with formatting and linting tools
- **Themed**: Dynamic themes with [matugen](https://github.com/InioX/matugen)

## Installation

### On NixOS

```bash
git clone https://github.com/deepzS2/dotfiles.git
cd dotfiles
nix develop

# On devshell
switch <hostname>
```

## Structure

```
.
├── flake.nix              # Main entry point
├── config/                # Application configuration files
│   ├── matugen/           # Theme generator configs
│   ├── nushell/           # Shell configuration
│   ├── nvim/              # Neovim Lua configs
│   ├── rofi/              # Launcher themes
│   └── tmux.conf          # Tmux config
├── media/                 # Wallpapers and media files
└── modules/
    ├── lib.nix            # Helper functions (mkNixos, homeFactory, mkHomeManager)
    ├── configurations.nix # NixOS configuration declarations
    ├── core/              # Merged core modules (NixOS + Home-Manager)
    ├── features/          # Feature modules by category
    │   ├── wm/            # Window managers (niri, hyprland)
    │   ├── terminal/      # Terminal tools (nvim, nushell, git, tmux)
    │   ├── gui/           # GUI apps (browser, vscode, discord, obs)
    │   ├── dev/           # Development languages (rust, go, javascript, elixir)
    │   ├── scripts/       # Custom utility scripts
    │   └── misc/          # Theme, notifications, secrets, virtualisation
    ├── hosts/             # Host-specific configurations
    ├── meta/              # Flake-parts meta configuration and devshell
    ├── options/           # Shared options (settings.user, settings.wm, settings.monitors)
    └── presets/           # Module bundles (base preset)
```

All modules auto-discovered via [import-tree](https://github.com/vic/import-tree).

### Core Modules (`modules/core/`)

Core modules feed into `flake.modules.nixos.core` and/or `flake.modules.homeManager.core`:

| Module | Description |
|--------|-------------|
| `settings.nix` | Common nix settings, flakes config, caches, overlays |
| `home.nix` | Home-manager integration and home directory setup |
| `graphics.nix` | Base graphics + GPU-specific modules (AMD, Intel, NVIDIA) |
| `bootloader.nix` | Limine bootloader with secure boot support |
| `fonts.nix` | Font packages |
| `audio.nix` | PipeWire audio and Bluetooth |
| `network.nix` | NetworkManager configuration |
| `locale.nix` | Timezone, locale, keyboard layout |
| `power.nix` | TLP power management |
| `greeter.nix` | tuigreet login manager |

## Development

Enter the development shell for all tools:

```bash
nix develop # Or use direnv
```

## Credits & Thanks

Special thanks to the amazing NixOS community and these individuals/projects that helped me on this journey:

- [Jet](https://github.com/Michael-C-Buckley/nixos) for helping me through a lot of questions and showing me his configuration
- [Vimjoyer](https://www.youtube.com/@vimjoyer) and [tonybtw](https://www.youtube.com/@tony-btw) for the awesome videos about Nix and NixOS
- [NixOS Wiki](https://nixos.wiki/) for also providing helpful content
- [Misterio77](https://github.com/Misterio77/nix-config), [argos-nothing](https://github.com/argosnothing/nixos-config), [vic](https://github.com/vic/vix), [Doc-Steve](https://github.com/Doc-Steve/dendritic-design-with-flake-parts) for flake structure inspiration
- And the Nix community in general

## References

- [flake-parts](https://flake.parts/) - Modular flake framework
- [Dendrix by Vic](https://vic.github.io/dendrix/index.html) - for listing repositories with **Dendritic Pattern**
- [Dendritic Pattern](https://github.com/mightyiam/dendritic) - Pattern for module organization
- [import-tree](https://github.com/vic/import-tree) - Auto module discovery
- [Home Manager](https://github.com/nix-community/home-manager) - User config management

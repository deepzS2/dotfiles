<h1 align="center">deepzS2's NixOS Dotfiles</h1>

<p align="center">
  <a href="https://builtwithnix.org">
    <img src="https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a" alt="Built with Nix">
  </a>
</p>

NixOS configuration using [flake-parts](https://flake.parts/) with self-registering modules following the [Dendritic Pattern](https://github.com/mightyiam/dendritic).

> **Note**: This repository contains all my configurations for software development. I do not use it as my primary system for now, but as a dedicated development environment.

## Highlights

- **Declarative**: Fully declarative NixOS and Home Manager configurations
- **Self-Registering Modules**: Modules auto-register via `flake.modules.nixos.*` and `flake.modules.homeManager.*`
- **Merged Core Modules**: Common configurations combined in `modules/core/` for cleaner organization
- **Feature-Based Organization**: Modules organized by function (terminal, gui, dev, wm) rather than by system type
- **Secure**: Secrets management using agenix via private `nix-secrets` repository
- **Development-ready**: Comprehensive dev shell with formatting, linting, and testing tools
- **Themed**: Dynamic theming with matugen (Material You color generation)
- **Extensible**: Easy to add new modules and hosts

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

All modules are automatically discovered via [import-tree](https://github.com/vic/import-tree).

### Core Modules (`modules/core/`)

The core modules are merged configurations that contribute to `flake.modules.nixos.core` and/or `flake.modules.homeManager.core`:

| Module | Description |
|--------|-------------|
| `settings.nix` | Common nix settings, flakes config, caches, overlays |
| `home.nix` | Home-manager integration and home directory setup |
| `graphics.nix` | Base graphics + GPU-specific modules (AMD, Intel, NVIDIA) |
| `bootloader.nix` | Limine bootloader with secure boot support |
| `fonts.nix` | Font packages (JetBrains Mono, Iosevka, etc.) |
| `audio.nix` | PipeWire audio and Bluetooth |
| `network.nix` | NetworkManager configuration |
| `locale.nix` | Timezone, locale, keyboard layout |
| `power.nix` | TLP power management |
| `greeter.nix` | tuigreet login manager |

### Shared Options (`modules/options/`)

Simplified top-level options shared across NixOS and Home-Manager:

- `settings.user` - Username
- `settings.wm` - Window manager selection (`"niri"` or `"hyprland"`)
- `settings.monitors` - Monitor configurations
- `flake.directories.config` / `flake.directories.media` - Directory references

## Secrets Management

This configuration uses a private `nix-secrets` repository for managing sensitive data such as API keys, SSH keys, and other credentials. The secrets are encrypted using [agenix](https://github.com/ryantm/agenix), which provides age-encrypted secrets for NixOS.

## Development

Enter the development shell for all tools:

```bash
nix develop # Or use direnv
```

### Commands

**Styling**
| Command | Description |
|---------|-------------|
| `fmt` | Run `nix fmt` |
| `lint` | Run deadnix and statix checks |

**Building**
| Command | Description |
|---------|-------------|
| `switch <host> [--target nixos\|home]` | Rebuild and switch (NixOS or Home-Manager) |
| `test <host>` | Build and activate NixOS configuration |

**REPL**
| Command | Description |
|---------|-------------|
| `repl <host> [--target nixos\|home]` | Open nix repl for the flake |
| `inspector` | TUI repl inspector via nix-inspect |

**Misc**
| Command | Description |
|---------|-------------|
| `fetch-url-hash <url>` | Prefetch URL and convert to SHA-256 hash |

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

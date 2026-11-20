# dotz

[![Built with Nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org)

My NixOS config, orchestrated by [adios-flake](https://github.com/Mic92/adios-flake) with plain NixOS and [hjem](https://github.com/feel-co/hjem) modules.

> **Note**: This is my development environment, not my primary system.

## Highlights

- **Declarative**: NixOS and user configs via [hjem](https://github.com/feel-co/hjem)
- **Single-Document Hosts**: `hosts/<host>/default.nix` answers "what does this machine run?" at a glance
- **Two-Layer Module Taxonomy**: `nixos/` (system layer, flat optionals) and `hjem/` (user layer, by functional role)
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
├── flake.nix              # Main entry point (adios-flake orchestration)
├── devshell.nix           # devShells.default (numtide/devshell standalone)
├── lib/
│   └── import-tree.nix    # The single importTree helper (Core of each layer)
├── nixos/                 # System layer (NixOS modules)
│   ├── core/              # Always-on modules (audio, bootloader, fonts, graphics, greeter, locale, network, nix, user/hjem integration, wm)
│   └── *.nix              # Optional modules: amd, nvidia, mango, niri, gaming, nh, obs, portal, fhs, localsend, virtualisation
├── hjem/                  # User layer (hjem modules)
│   ├── core/              # Structural options (monitors, window-manager)
│   ├── desktop/           # Compositors, launcher, idle, media, scripts, terminal, theme
│   ├── programs/          # User apps (browser, git, nushell, nvim, vscode, ...)
│   ├── dev/               # Toolchains (common, elixir, go, javascript, rust)
│   └── services/          # systemd --user services (syncthing)
├── hosts/
│   ├── tojo/              # Laptop: single document + hardware descriptor
│   └── omi/               # Desktop: single document + hardware descriptor
├── packages/              # Custom packages (kanagawa-gtk-theme, mister-download-manager)
├── config/                # Application configuration files
└── media/                 # Wallpapers and media files
```

Optional modules are activated by explicit import in the host document; only `nixos/core/` and `hjem/core/` are bulk-loaded via [import-tree.nix](./lib/import-tree.nix).

## Development

Enter the development shell for all tools:

```bash
nix develop # Or use direnv
```

Available commands: `lint` (statix + deadnix), `fmt`, `inspector`, `repl <host>`, `switch <host>`, `boot <host>`, `fetch-url-hash`.

## Credits & Thanks

Special thanks to the amazing NixOS community and these individuals/projects that helped me on this journey:

- [Jet](https://github.com/Michael-C-Buckley/nixos) for helping me through a lot of questions and showing me his configuration
- [Vimjoyer](https://www.youtube.com/@vimjoyer) and [tonybtw](https://www.youtube.com/@tony-btw) for the awesome videos about Nix and NixOS
- [NixOS Wiki](https://nixos.wiki/) for also providing helpful content
- [Misterio77](https://github.com/Misterio77/nix-config), [argos-nothing](https://github.com/argosnothing/nixos-config) for flake structure inspiration
- And the Nix community in general

## References

- [adios-flake](https://github.com/Mic92/adios-flake) - Flake output orchestration without flake-parts overhead
- [adios by adisbladis](https://github.com/adisbladis/adios) - Memoized module system powering adios-flake
- [hjem](https://github.com/feel-co/hjem) - NixOS-integrated home management

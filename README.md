<h1 align="center">deepzS2's NixOS Dotfiles</h1>

<p align="center">
  <a href="https://builtwithnix.org">
    <img src="https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a" alt="Built with Nix">
  </a>
</p>

NixOS configuration using [flake-parts](https://flake.parts/) with self-registering modules following the [Dendritic Pattern](https://github.com/mightyiam/dendritic).

## ✨ Highlights

- **Declarative**: Fully declarative NixOS and Home Manager configurations
- **Modular**: Auto-imported modules with clean separation of concerns
- **Multi-host**: Support for multiple hosts (desktop, laptop, server)
- **Development-ready**: Comprehensive dev shell with formatting, linting, and testing tools
- **Extensible**: Easy to add new modules and hosts

## 🚀 Installation

### On NixOS

```bash
git clone https://github.com/deepzS2/dotfiles.git
cd dotfiles
nix flake update
sudo nixos-rebuild switch --flake .#deepz
```

### On Non-NixOS Systems

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
git clone https://github.com/deepzS2/dotfiles.git
cd dotfiles
home-manager switch --flake .#deepz
```

_Note: Replace `#deepz` with your host configuration name._

## 📁 Structure

```
modules/
├── flake/          # Flake outputs and utilities
├── nixos/          # System-level modules (audio, drivers, network, etc.)
├── home-manager/   # User-level modules (apps, shell, editor, etc.)
└── hosts/          # Host-specific configurations
```

All modules are automatically discovered via [import-tree](https://github.com/vic/import-tree).

## 🛠️ Development

Enter the development shell for all tools:

```bash
nix develop
```

Common commands:

- `nix fmt` - Format Nix files
- `statix check . && deadnix .` - Lint and check for unused code
- `nix flake check` - Validate flake

## 🙏 Credits & Thanks

Special thanks to the amazing NixOS community and these individuals/projects that helped me on this journey:

- [Jet](https://github.com/Michael-C-Buckley/nixos) for helping me through a lot of questions and showing me his configuration
- [Vimjoyer](https://www.youtube.com/@vimjoyer) and [tonybtw](https://www.youtube.com/@tony-btw) for the awesome videos about Nix and NixOS
- [NixOS Wiki](https://nixos.wiki/) for also providing helpful content
- [Misterio77](https://github.com/Misterio77/nix-config), [argos-nothing](https://github.com/argosnothing/nixos-config), [vic](https://github.com/vic/vix) for flake structure inspiration.
- And the Nix community in general

## 📚 References

- [flake-parts](https://flake.parts/) - Modular flake framework
- [Dendrix by Vic](https://vic.github.io/dendrix/index.html) - for listing repositories with **Dendritic Pattern**
- [Dendritic Pattern](https://github.com/mightyiam/dendritic) - Pattern for module organization
- [import-tree](https://github.com/vic/import-tree) - Auto module discovery
- [Home Manager](https://github.com/nix-community/home-manager) - User config management

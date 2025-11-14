<h1 align="center">deepzS2's NixOS Dotfiles</h1>

<p align="center">
  <a href="https://builtwithnix.org">
    <img src="https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a" alt="Built with Nix">
  </a>
</p>

NixOS configuration using [flake-parts](https://flake.parts/) with self-registering modules following the [Dendritic Pattern](https://github.com/mightyiam/dendritic).

> **Note**: This repository contains all my configurations for software development. I do not use it as my primary system for now, but as a dedicated development environment.

## ✨ Highlights

- **Declarative**: Fully declarative NixOS and Home Manager configurations
- **Modular**: Auto-imported modules with clean separation of concerns
- **Multi-host**: Support for multiple hosts (desktop, laptop, server)
- **Secure**: Secrets management using agenix via private `nix-secrets` repository (protects against "harvest now, decrypt later" attacks)
- **Development-ready**: Comprehensive dev shell with formatting, linting, and testing tools, plus language-specific environments (Rust, Go, JavaScript, Elixir)
- **Themed**: Consistent system theming with Stylix
- **Extensible**: Easy to add new modules and hosts

## 🚀 Installation

### On NixOS

```bash
git clone https://github.com/deepzS2/dotfiles.git
cd dotfiles
nix develop

# On devshell
switch <hostname>
```

## 📁 Structure

```
modules/
├── flake/          # Flake outputs and utilities
├── nixos/          # System-level modules (audio, drivers, network, etc.)
├── home-manager/   # User-level modules (apps, shell, editor, etc.)
└── hosts/          # Host-specific configurations
```

All modules are automatically discovered via [import-tree](https://github.com/vic/import-tree).

## 🔐 Secrets Management

This configuration uses a private `nix-secrets` repository for managing sensitive data such as API keys, SSH keys, and other credentials. The secrets are encrypted using [agenix](https://github.com/ryantm/agenix), which provides age-encrypted secrets for NixOS. This approach protects against "harvest now, decrypt later" attacks by keeping secrets in a separate private repository that is only accessible with proper SSH authentication.

## 🛠️ Development

Enter the development shell for all tools:

```bash
nix develop
```

Common commands:

- `format` - Format Nix files
- `lint` - Lint and check for unused code
- `nix flake check` - Validate flake
- `nix flake update` - Update flake dependencies
- `fetch-url-hash` - Nix prefetch URL then converts to SHA-256 hash

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

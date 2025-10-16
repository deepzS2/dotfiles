# deepzS2's NixOS Dotfiles

NixOS configuration using flake-parts with self-registering modules.

## Quick Start

```bash
# Update and rebuild
nix flake update
sudo nixos-rebuild switch --flake .#default
home-manager switch --flake .#deepz@default
```

## Structure

```
modules/
├── flake/          # Flake outputs (formatter, packages, dev-shells, overlays, configs)
├── nixos/          # System modules (audio, containers, drivers, fonts, locale, network)
└── home-manager/   # User modules (git, nvim, shell, layout, applications, development, etc.)
```

All modules auto-imported via [import-tree](https://github.com/vic/import-tree). Just create a `.nix` file and it's available.

## Module Pattern

Each module self-registers:

```nix
# modules/home-manager/git.nix
{
  flake.modules.homeManager.git = {pkgs, ...}: {
    programs.git = {
      enable = true;
      userName = "deepzS2";
      userEmail = "alanr.developer@hotmail.com";
    };
  };
}
```

Import modules in host configs:

```nix
# hosts/default/home.nix
{self, ...}: {
  imports = with self.modules.homeManager; [
    git
    nvim
    hyprland
  ];
}
```

## Usage in Other Projects

```nix
{
  inputs.deepz-dotfiles.url = "github:deepzS2/dotfiles";
  
  imports = [
    inputs.deepz-dotfiles.modules.homeManager.git
    inputs.deepz-dotfiles.modules.nixosModules.audio
  ];
}
```

## Development

```bash
nix fmt              # Format code
nix develop          # Dev shell
nix flake check      # Validate flake
```

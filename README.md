# NixOS Configuration with flake-parts

This repository contains my personal NixOS configuration, organized using [flake-parts](https://flake.parts/) for a modular and maintainable setup.

## 🚀 Quick Start

### Prerequisites

- NixOS with Flakes enabled
- Git

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/deepzS2/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Build and switch to the configuration:
   ```bash
   sudo nixos-rebuild switch --flake .#default
   ```

3. For home-manager changes only:
   ```bash
   home-manager switch --flake .#deepz@default
   ```

## 📁 Repository Structure

```
.
├── flake.nix                    # Main flake entry point (uses flake-parts)
├── flake.lock                   # Locked dependencies
├── parts/                       # Flake-parts modules
│   ├── nixos-configurations.nix # System configurations
│   ├── overlays.nix            # Nixpkgs overlays
│   └── formatter.nix           # Code formatter configuration
├── hosts/                       # Host-specific configurations
│   └── default/
│       ├── configuration.nix    # NixOS system configuration
│       ├── hardware-configuration.nix  # Hardware-specific settings
│       └── home.nix            # Home Manager user configuration
├── modules/                     # Reusable modules
│   ├── nixos/                  # NixOS system modules
│   │   ├── audio.nix           # Audio/Bluetooth configuration
│   │   ├── containers.nix      # Container/Docker setup
│   │   ├── display-manager.nix # Display manager settings
│   │   ├── drivers/            # Hardware drivers (AMD, Intel, NVIDIA)
│   │   ├── fonts.nix           # Font configuration
│   │   ├── locale.nix          # Localization settings
│   │   └── network.nix         # Network configuration
│   └── home-manager/           # Home Manager modules
│       ├── applications/        # Desktop applications
│       ├── development/         # Development tools (Go, Rust, JS, etc.)
│       ├── editor/             # Text editors (VSCode, Neovim)
│       ├── layout/             # Desktop environment (Hyprland, Waybar, etc.)
│       ├── shell/              # Shell configuration (Nushell, tmux, etc.)
│       └── git.nix             # Git configuration
├── overlays/                    # Nixpkgs overlays
│   └── default.nix             # VSCode extensions overlay
├── config/                      # Application configurations
│   ├── nvim/                   # Neovim config
│   ├── rofi/                   # Rofi launcher config
│   ├── waybar/                 # Waybar config
│   └── theme/                  # Theme files and wallpapers
└── secrets/                     # Encrypted secrets (agenix)
```

## 🎯 Features

### System Features
- **Bootloader**: Limine with Secure Boot support
- **Display**: Hyprland Wayland compositor
- **Audio**: PipeWire with Bluetooth support
- **Drivers**: Modular driver support (AMD, Intel, NVIDIA)
- **Containers**: Docker support

### Development Tools
- **Languages**: Go, Rust, JavaScript/Node.js, Elixir
- **Editors**: VSCode, Neovim (nixCats)
- **Shell**: Nushell with custom prompt (Starship)
- **Terminal**: Kitty with tmux

### Desktop Environment
- **Compositor**: Hyprland
- **Bar**: Waybar with custom styling
- **Launcher**: Rofi
- **Notifications**: Dunst/Mako
- **Theme**: Managed by Stylix
- **Browser**: Zen Browser (Firefox-based)

## 🔧 Configuration

### Adding a New Host

1. Create a new directory under `hosts/`:
   ```bash
   mkdir -p hosts/my-new-host
   ```

2. Add configuration files:
   - `configuration.nix` - System configuration
   - `hardware-configuration.nix` - Hardware settings
   - `home.nix` - User configuration

3. Add the host to `parts/nixos-configurations.nix`:
   ```nix
   flake.nixosConfigurations = {
     my-new-host = withSystem "x86_64-linux" ({system, ...}:
       inputs.nixpkgs.lib.nixosSystem {
         inherit system;
         specialArgs = {inherit inputs system;};
         modules = [
           ../hosts/my-new-host/configuration.nix
           # ... other modules
         ];
       }
     );
   };
   ```

### Enabling/Disabling Modules

Modules are configured in `hosts/default/home.nix`. Simply toggle the `enable` option:

```nix
{
  # Enable Git
  git.enable = true;
  
  # Enable development tools
  development = {
    rust.enable = true;
    go.enable = true;
  };
  
  # Enable applications
  applications = {
    browser.enable = true;
    discord.enable = true;
  };
}
```

### Managing Secrets

Secrets are managed using [agenix](https://github.com/ryantm/agenix). See `secrets/` directory.

## 🛠️ Maintenance

### Update Flake Inputs
```bash
nix flake update
```

### Update Specific Input
```bash
nix flake lock --update-input nixpkgs
```

### Format Nix Code
```bash
nix fmt
```

### Check Flake
```bash
nix flake check
```

### Clean Old Generations
```bash
sudo nix-collect-garbage --delete-older-than 7d
```

## 📚 Documentation

For detailed information about the flake-parts architecture and how to extend this configuration, see [FLAKE_PARTS_GUIDE.md](./FLAKE_PARTS_GUIDE.md).

## 🤝 Contributing

This is a personal configuration, but feel free to:
- Use it as inspiration for your own config
- Submit issues if you find bugs
- Suggest improvements via pull requests

## 📝 License

This configuration is provided as-is for educational and personal use.

## 🙏 Credits

Built with:
- [NixOS](https://nixos.org/)
- [flake-parts](https://flake.parts/)
- [home-manager](https://github.com/nix-community/home-manager)
- [Hyprland](https://hyprland.org/)
- [Stylix](https://github.com/danth/stylix)
- And many other amazing Nix community projects!

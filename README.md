# deepzS2's NixOS Dotfiles

NixOS configuration using [flake-parts](https://flake.parts/) with self-registering modules following the [Dendritic Pattern](https://github.com/mightyiam/dendritic).

## Installation

### On NixOS

1. **Clone the repository:**

```bash
git clone https://github.com/deepzS2/dotfiles.git
cd dotfiles
```

2. **Update flake inputs:**

```bash
nix flake update
```

3. **Apply NixOS configuration:**

```bash
sudo nixos-rebuild switch --flake .#default
```

4. **Apply Home Manager configuration (standalone, if needed):**

```bash
home-manager switch --flake .#default
```

### On Non-NixOS Systems (Ubuntu, Debian, etc.)

1. **Install Nix (if not already installed):**

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

2. **Clone the repository:**

```bash
git clone https://github.com/deepzS2/dotfiles.git
cd dotfiles
```

3. **Apply Home Manager configuration (using the default configuration):**

```bash
home-manager switch --flake .#default
```

_Note: The default configuration is set up for user "deepz". For custom setups, create a new host in `modules/hosts/your-hostname/default.nix` as described in the "Adding New Hosts" section._

## Structure

```
modules/
├── flake/          # Flake outputs (formatter, packages, dev-shells, overlays, hosts)
├── nixos/          # System modules (audio, containers, drivers, fonts, locale, network)
├── home-manager/   # User modules (git, nvim, shell, layout, applications, development)
└── hosts/          # Host configurations (self-registering nixos & homeManager modules)
```

All modules are auto-imported via [import-tree](https://github.com/vic/import-tree). Just create a `.nix` file and it's automatically available.

## Architecture

This configuration follows the [**Dendritic Pattern**](https://github.com/mightyiam/dendritic), where each module:

- Is a flake-parts module
- Implements a single feature
- Spans across all module classes it applies to
- Is at a path that serves to name the feature

### Module Pattern

Each module self-registers in `flake.modules`:

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
# modules/hosts/default/default.nix
{config, ...}: {
  flake.modules = {
    nixos.default = {inputs, ...}: {
      imports = with config.flake.modules.nixosModules; [
        audio
        containers
        display-manager
      ];
    };

    homeManager.default = {inputs, ...}: {
      imports = with config.flake.modules.homeManager; [
        git
        nvim
        hyprland
      ];
    };
  };
}
```

## Adding New Modules

### 1. Create a Home Manager Module

Create `modules/home-manager/my-feature.nix`:

```nix
{
  flake.modules.homeManager.my-feature = {pkgs, ...}: {
    # Your Home Manager configuration
    home.packages = [ pkgs.my-package ];
  };
}
```

The module is automatically discovered by import-tree!

### 2. Create a NixOS Module

Create `modules/nixos/my-feature.nix`:

```nix
{
  flake.modules.nixosModules.my-feature = {pkgs, ...}: {
    # Your NixOS configuration
    services.my-service.enable = true;
  };
}
```

### 3. Create a Multi-Class Module (Dendritic Pattern)

Create `modules/my-feature/default.nix`:

```nix
{
  # Implements across both NixOS and Home Manager
  flake.modules = {
    nixosModules.my-feature = {pkgs, ...}: {
      # NixOS configuration
    };

    homeManager.my-feature = {pkgs, ...}: {
      # Home Manager configuration
    };
  };
}
```

### 4. Import in Host

Add to your host configuration:

```nix
{config, ...}: {
  flake.modules.homeManager.default = {inputs, ...}: {
    imports = with config.flake.modules.homeManager; [
      my-feature  # ← Your new module
    ];
  };
}
```

## Adding New Hosts

### NixOS Host

Create `modules/hosts/my-host/default.nix`:

```nix
{config, ...}: {
  flake.modules = {
    nixos.my-host = {inputs, pkgs, ...}: {
      imports = [
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default
      ] ++ (with config.flake.modules.nixosModules; [
        audio
        # ... other modules
      ]);

      # NixOS configuration
      networking.hostName = "my-host";
      system.stateVersion = "24.11";

      home-manager.users."myuser" = config.flake.modules.homeManager.my-host;
    };

    homeManager.my-host = {inputs, ...}: {
      imports = with config.flake.modules.homeManager; [
        git
        # ... other modules
      ];

      home.username = "myuser";
      home.homeDirectory = "/home/myuser";
      home.stateVersion = "24.11";
    };
  };
}
```

### Home Manager Only Host

Create `modules/hosts/ubuntu-laptop/default.nix`:

```nix
{self, ...}: {
  flake.modules.homeManager.ubuntu-laptop = {inputs, ...}: {
    imports = with config.flake.modules.homeManager; [
      git
      nvim
      # ... only Home Manager modules
    ];

    home.username = "myuser";
    home.homeDirectory = "/home/myuser";
    home.stateVersion = "24.11";
  };
}
```

## Development

This repository includes a development shell with all necessary tools.

**Enter the development shell:**

```bash
nix develop
```

**Available tools in dev shell:**

- `alejandra` - Nix code formatter
- `statix` - Nix linter and static analysis
- `deadnix` - Find and remove unused Nix code
- `nil` - Nix language server

**Common development commands:**

```bash
nix fmt              # Format all Nix files
nix flake check      # Validate flake structure
statix check .       # Run static analysis
deadnix .            # Find unused code
```

## Usage in Other Projects

You can import individual modules from this flake:

```nix
{
  inputs.deepz-dotfiles.url = "github:deepzS2/dotfiles";

  outputs = {deepz-dotfiles, ...}: {
    # Use in Home Manager
    homeConfigurations.myuser = {
      imports = [
        deepz-dotfiles.modules.homeManager.git
        deepz-dotfiles.modules.homeManager.nvim
      ];
    };

    # Use in NixOS
    nixosConfigurations.myhost = {
      imports = [
        deepz-dotfiles.modules.nixosModules.audio
        deepz-dotfiles.modules.nixosModules.containers
      ];
    };
  };
}
```

## References

- [flake-parts](https://flake.parts/) - Flake framework for modularity
- [Dendritic Pattern](https://github.com/mightyiam/dendritic) - Module organization pattern
- [import-tree](https://github.com/vic/import-tree) - Automatic module discovery
- [Home Manager](https://github.com/nix-community/home-manager) - User environment management
- [NixOS](https://nixos.org/) - Declarative Linux distribution

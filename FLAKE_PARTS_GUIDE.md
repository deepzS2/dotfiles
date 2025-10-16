# Flake-parts Architecture Guide

This guide explains the flake-parts architecture used in this NixOS configuration and how to work with it effectively.

## Table of Contents

1. [What is flake-parts?](#what-is-flake-parts)
2. [Architecture Overview](#architecture-overview)
3. [Module System](#module-system)
4. [Creating New Modules](#creating-new-modules)
5. [Dendritic Pattern](#dendritic-pattern)
6. [Best Practices](#best-practices)
7. [Troubleshooting](#troubleshooting)

## What is flake-parts?

[flake-parts](https://flake.modules/flake/) is a framework for writing Nix flakes in a modular way. Instead of having all configuration in a single `flake.nix` file, flake-parts allows you to:

- **Split configuration** into logical, reusable modules
- **Compose modules** from different sources
- **Share modules** across multiple flakes
- **Reduce boilerplate** in flake outputs
- **Type-safe configuration** with better error messages

### Benefits Over Traditional Flakes

**Before (Traditional Flake):**
```nix
{
  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem { ... };
    packages.x86_64-linux.mypackage = ...;
    devShells.x86_64-linux.default = ...;
    formatter.x86_64-linux = ...;
  };
}
```

**After (flake-parts):**
```nix
{
  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./modules/flake/nixos-configurations.nix
        ./modules/flake/packages.nix
        ./modules/flake/formatter.nix
      ];
      systems = ["x86_64-linux"];
    };
}
```

## Architecture Overview

### Directory Structure

```
.
├── flake.nix                    # Entry point - imports flake-parts modules
├── modules/                     # All modules organized by type
│   ├── flake/                   # Flake-parts modules (exported as modules)
│   │   ├── nixos-configurations.nix # Defines NixOS system configurations
│   │   ├── overlays.nix            # Defines nixpkgs overlays
│   │   ├── formatter.nix           # Defines code formatter
│   │   ├── packages.nix            # Custom packages
│   │   └── dev-shells.nix          # Development environments
│   ├── nixos/                   # NixOS system modules
│   └── home-manager/            # Home Manager modules
├── hosts/                       # Host-specific configurations
│   └── default/
│       ├── configuration.nix    # NixOS config
│       └── home.nix            # Home Manager config
└── overlays/                    # Additional overlays
```

### Main Components

#### 1. `flake.nix` (Entry Point)

The main flake file is minimal and delegates to flake-parts:

```nix
{
  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./modules/flake/nixos-configurations.nix
        ./modules/flake/overlays.nix
        ./modules/flake/formatter.nix
      ];
      systems = ["x86_64-linux"];
      
      # Export modules organized by class for reuse in other flakes
      flake.modules = {
        generic = {
          nixos-configurations = ./modules/flake/nixos-configurations.nix;
          overlays = ./modules/flake/overlays.nix;
          formatter = ./modules/flake/formatter.nix;
        };
        nixosModules = {
          audio = ./modules/nixos/audio.nix;
          # ... other NixOS modules
        };
        homeModules = {
          git = ./modules/home-manager/git.nix;
          # ... other Home Manager modules
        };
      };
    };
}
```

**Key elements:**
- `mkFlake` - Creates the flake with flake-parts
- `imports` - List of flake-parts modules to include
- `systems` - Supported systems (used by `perSystem`)
- `flake.modules` - Export modules organized by class (generic, nixosModules, homeModules)

#### 2. `modules/` Directory

Contains all modules organized by type:

**`modules/flake/`** - Flake-parts modules that define outputs:
- **nixos-configurations.nix** - Defines `nixosConfigurations` output
- **overlays.nix** - Defines `overlays` output
- **formatter.nix** - Defines `formatter` per-system output
- **packages.nix** - Defines `packages` per-system output
- **dev-shells.nix** - Defines `devShells` per-system output

**`modules/nixos/`** - NixOS system modules:
- Audio, containers, display-manager, drivers, fonts, locale, network, etc.

**`modules/home-manager/`** - Home Manager modules:
- Applications, development, editor, git, layout, shell, etc.

All modules are exported via `flake.modules` organized by class for reuse in other projects.

#### 3. `hosts/` Directory

Contains host-specific configurations that are imported by the nixos-configurations module.

#### 4. `modules/` Directory

Contains reusable NixOS and Home Manager modules organized by category.

## Module System

### Flake-parts Module Structure

A flake-parts module is a Nix file that returns an attribute set with specific keys:

```nix
{
  inputs,      # Flake inputs
  self,        # The flake itself
  lib,         # Nixpkgs lib
  config,      # Module configuration
  ...
}: {
  # Module content
}
```

### Two Types of Outputs

#### 1. Flake-level Outputs

Defined with `flake.*`:

```nix
{
  flake.nixosConfigurations = {
    myhost = ...;
  };
  
  flake.overlays = {
    default = ...;
  };
}
```

These are outputs that don't depend on system architecture.

#### 2. Per-system Outputs

Defined with `perSystem`:

```nix
{
  perSystem = {pkgs, system, ...}: {
    packages.mypackage = ...;
    formatter = pkgs.alejandra;
    devShells.default = ...;
  };
}
```

These outputs are automatically generated for each system in the `systems` list.

### Using `withSystem`

When you need to access per-system values in flake-level outputs, use `withSystem`:

```nix
{
  inputs,
  withSystem,
  ...
}: {
  flake.nixosConfigurations = {
    myhost = withSystem "x86_64-linux" ({system, pkgs, ...}:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        # Now you can use per-system values
      }
    );
  };
}
```

## Creating New Modules

### Example: Creating a Packages Module

Let's create `modules/flake/packages.nix` to define custom packages:

```nix
# modules/flake/packages.nix
{
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages = {
      # Custom package example
      my-script = pkgs.writeShellScriptBin "my-script" ''
        echo "Hello from my custom script!"
      '';
      
      # You can also reference packages from your modules
      default = pkgs.hello;
    };
  };
}
```

Then add it to `flake.nix`:

```nix
{
  imports = [
    ./modules/flake/nixos-configurations.nix
    ./modules/flake/overlays.nix
    ./modules/flake/formatter.nix
    ./modules/flake/packages.nix  # Add this line
  ];
}
```

### Example: Creating a Dev Shell Module

Create `modules/flake/dev-shells.nix`:

```nix
# modules/flake/dev-shells.nix
{
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    devShells = {
      default = pkgs.mkShell {
        name = "nixos-config-dev";
        packages = with pkgs; [
          alejandra  # Nix formatter
          nil        # Nix LSP
          git
        ];
        
        shellHook = ''
          echo "Welcome to NixOS config development environment!"
          echo "Available commands:"
          echo "  - nix fmt  (format Nix code)"
          echo "  - nix flake check  (validate configuration)"
        '';
      };
    };
  };
}
```

### Example: Adding More System Configurations

Edit `modules/flake/nixos-configurations.nix`:

```nix
{
  inputs,
  withSystem,
  ...
}: {
  flake.nixosConfigurations = {
    # Existing default configuration
    default = withSystem "x86_64-linux" ({system, ...}:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs system;};
        modules = [../hosts/default/configuration.nix];
      }
    );
    
    # New laptop configuration
    laptop = withSystem "x86_64-linux" ({system, ...}:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs system;};
        modules = [../hosts/laptop/configuration.nix];
      }
    );
    
    # Server configuration
    server = withSystem "x86_64-linux" ({system, ...}:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs system;};
        modules = [../hosts/server/configuration.nix];
      }
    );
  };
}
```

## Dendritic Pattern

The Dendritic Pattern is an organizational philosophy for Nix configurations:

### Principles

1. **Hierarchical Structure**: Like dendrites (tree branches), configuration grows from a central point
2. **Modular Organization**: Each branch (module) has a specific purpose
3. **Reusability**: Modules can be shared and composed
4. **Clear Dependencies**: Each module declares its dependencies explicitly

### Implementation in This Configuration

```
flake.nix (root)
  ├── modules/flake/ (branches for flake outputs)
  │   ├── nixos-configurations.nix
  │   ├── overlays.nix
  │   └── formatter.nix
  ├── hosts/ (branches for specific hosts)
  │   └── default/
  └── modules/ (branches for reusable functionality)
      ├── nixos/ (system-level modules)
      │   ├── audio.nix
      │   ├── drivers/
      │   └── ...
      └── home-manager/ (user-level modules)
          ├── applications/
          ├── development/
          └── ...
```

### Benefits

- **Easy Navigation**: Clear hierarchy makes finding configuration easy
- **Isolated Changes**: Modify one branch without affecting others
- **Scalability**: Add new branches without restructuring
- **Testability**: Test individual modules independently

## Best Practices

### 1. Keep Modules Focused

Each module should have a single, well-defined purpose:

✅ **Good:**
```nix
# modules/flake/formatter.nix - Only defines formatter
{
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
```

❌ **Bad:**
```nix
# modules/flake/formatter.nix - Mixed concerns
{
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
    packages.something = ...;  # Wrong module!
    devShells.default = ...;   # Wrong module!
  };
}
```

### 2. Use Descriptive Module Names

Name modules after what they define:
- `nixos-configurations.nix` - Defines `nixosConfigurations`
- `overlays.nix` - Defines `overlays`
- `packages.nix` - Defines `packages`
- `dev-shells.nix` - Defines `devShells`

### 3. Document Module Purpose

Add comments at the top of each module:

```nix
# Formatter module for flake-parts
# This module defines the default formatter for nix fmt
{
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
```

### 4. Use `withSystem` Correctly

Only use `withSystem` when you need per-system values in flake-level outputs:

```nix
# ✅ Correct: Need system for nixosSystem
flake.nixosConfigurations.myhost = withSystem "x86_64-linux" ({system, ...}:
  inputs.nixpkgs.lib.nixosSystem {inherit system; ...}
);

# ✅ Correct: Flake-level output, no system needed
flake.overlays.default = final: prev: {...};

# ✅ Correct: Per-system output
perSystem = {pkgs, ...}: {
  packages.mypackage = pkgs.hello;
};
```

### 5. Organize Imports Logically

In `flake.nix`, group imports by category:

```nix
{
  imports = [
    # Core system configuration
    ./modules/flake/nixos-configurations.nix
    
    # Build tools
    ./modules/flake/formatter.nix
    ./modules/flake/packages.nix
    
    # Nixpkgs customization
    ./modules/flake/overlays.nix
    
    # Development
    ./modules/flake/dev-shells.nix
  ];
}
```

### 6. Keep Host Configurations Minimal

Host configurations should mostly enable/configure modules, not define new functionality:

✅ **Good:**
```nix
# hosts/laptop/configuration.nix
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];
  
  drivers.intel.enable = true;
  networking.hostName = "laptop";
}
```

❌ **Bad:**
```nix
# hosts/laptop/configuration.nix
{
  # Defining new functionality in host config
  environment.systemPackages = [ /* 50 packages */ ];
  # Better to create a module in modules/nixos/
}
```

## Troubleshooting

### Error: "attribute 'nixosConfigurations' missing"

**Cause:** Module not imported or incorrect syntax

**Solution:** Check that the module is imported in `flake.nix` and uses correct syntax:

```nix
# Correct
{
  flake.nixosConfigurations = { ... };
}

# Wrong
{
  nixosConfigurations = { ... };  # Missing 'flake.' prefix
}
```

### Error: "infinite recursion"

**Cause:** Circular dependency between modules

**Solution:** Review module imports and ensure no circular references. Use `config` carefully.

### Error: "system not defined"

**Cause:** Trying to use `system` outside of `perSystem` or `withSystem`

**Solution:** 
- Use `perSystem` for per-system outputs
- Use `withSystem` when accessing system-specific values in flake outputs

### Flake Check Fails

**Solution:**
```bash
# Check for syntax errors
nix flake check --show-trace

# Format code
nix fmt

# Validate specific configuration
nix eval .#nixosConfigurations.default.config.system.build.toplevel
```

### Module Not Loading

**Checklist:**
1. ✅ Module imported in `flake.nix`?
2. ✅ Syntax correct (proper attribute names)?
3. ✅ File path correct?
4. ✅ Module returns valid attribute set?

## Advanced Topics

### Sharing Modules Between Flakes

This configuration exports all modules organized by class via `flake.modules`, making them reusable in other projects:

```nix
# This flake exports modules organized by class
{
  flake.modules = {
    # Generic modules - flake-parts modules that can be used anywhere
    generic = {
      nixos-configurations = ./modules/flake/nixos-configurations.nix;
      overlays = ./modules/flake/overlays.nix;
      formatter = ./modules/flake/formatter.nix;
      packages = ./modules/flake/packages.nix;
      dev-shells = ./modules/flake/dev-shells.nix;
    };
    
    # NixOS modules - for NixOS system configuration
    nixosModules = {
      audio = ./modules/nixos/audio.nix;
      containers = ./modules/nixos/containers.nix;
      fonts = ./modules/nixos/fonts.nix;
      # ... other NixOS modules
    };
    
    # Home Manager modules - for home-manager configuration
    homeModules = {
      git = ./modules/home-manager/git.nix;
      applications = ./modules/home-manager/applications;
      shell = ./modules/home-manager/shell;
      # ... other Home Manager modules
    };
  };
}
```

Using exported modules in another flake:

**Using flake-parts modules (generic):**
```nix
{
  inputs.deepz-dotfiles.url = "github:deepzS2/dotfiles";
  
  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        # Import specific flake-parts modules you want to use
        inputs.deepz-dotfiles.modules.generic.formatter
        inputs.deepz-dotfiles.modules.generic.packages
        inputs.deepz-dotfiles.modules.generic.dev-shells
      ];
      
      systems = ["x86_64-linux"];
    };
}
```

**Using NixOS modules:**
```nix
{
  inputs.deepz-dotfiles.url = "github:deepzS2/dotfiles";
  
  # In your NixOS configuration
  imports = [
    inputs.deepz-dotfiles.modules.nixosModules.audio
    inputs.deepz-dotfiles.modules.nixosModules.fonts
    inputs.deepz-dotfiles.modules.nixosModules.drivers
  ];
}
```

**Using Home Manager modules:**
```nix
{
  inputs.deepz-dotfiles.url = "github:deepzS2/dotfiles";
  
  # In your Home Manager configuration
  imports = [
    inputs.deepz-dotfiles.modules.homeModules.git
    inputs.deepz-dotfiles.modules.homeModules.shell
    inputs.deepz-dotfiles.modules.homeModules.editor
  ];
}
```

This allows you to:
- Reuse the same formatter across projects
- Share helper packages and scripts
- Use the same development environment setup
- Maintain consistent configuration patterns

### Using flake-parts with Other Frameworks

flake-parts integrates well with:
- **hercules-ci-effects** - For CI/CD
- **devenv** - Development environments
- **process-compose-flake** - Service management
- **treefmt-nix** - Multi-language formatting

### Debugging

Enable trace output:
```bash
nix flake check --show-trace --print-build-logs
```

Evaluate specific outputs:
```bash
# Check nixosConfiguration
nix eval .#nixosConfigurations.default.config.networking.hostName

# Check packages
nix eval .#packages.x86_64-linux --apply builtins.attrNames

# Check formatter
nix eval .#formatter.x86_64-linux
```

## Resources

- [flake-parts Documentation](https://flake.modules/flake/)
- [flake-parts GitHub](https://github.com/hercules-ci/flake-parts)
- [NixOS Wiki - Flakes](https://nixos.wiki/wiki/Flakes)
- [Nix.dev - Flakes](https://nix.dev/concepts/flakes)
- [Zero to Nix - Flakes](https://zero-to-nix.com/concepts/flakes)

## Conclusion

The flake-parts architecture provides a clean, modular approach to organizing Nix flakes. By following the patterns and best practices outlined in this guide, you can create maintainable, scalable NixOS configurations that grow with your needs.

Remember:
- Keep modules focused and well-organized
- Use the Dendritic Pattern for clear hierarchy
- Document your modules
- Leverage `perSystem` for cross-platform support
- Test configurations frequently

Happy Nix hacking! 🎉

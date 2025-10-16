# Migration Guide: Traditional Flake to flake-parts

This document explains the changes made during the migration from a traditional Nix Flake to flake-parts architecture.

## What Changed?

### Structure Changes

#### Before (Traditional Flake)
```
.
├── flake.nix              # All configuration in one file
├── hosts/
├── modules/
└── overlays/
```

#### After (flake-parts)
```
.
├── flake.nix              # Entry point, imports modules
├── modules/               # All modules organized by type
│   ├── flake/            # NEW: Modular flake outputs (exported as modules)
│   │   ├── nixos-configurations.nix
│   │   ├── overlays.nix
│   │   ├── formatter.nix
│   │   ├── packages.nix
│   │   └── dev-shells.nix
│   ├── nixos/            # NixOS system modules
│   └── home-manager/     # Home Manager modules
├── hosts/
├── overlays/
└── config/
```

### File-by-File Changes

#### `flake.nix`

**Before:**
```nix
{
  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system;};
        modules = [
          ./hosts/default/configuration.nix
          (import ./overlays)
          {
            nixpkgs.config.allowUnfree = true;
            nix = { /* ... */ };
          }
        ];
      };
    };
  };
}
```

**After:**
```nix
{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    # ... other inputs
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./modules/flake/nixos-configurations.nix
        ./modules/flake/overlays.nix
        ./modules/flake/formatter.nix
        ./modules/flake/packages.nix
        ./modules/flake/dev-shells.nix
      ];
      systems = ["x86_64-linux"];
      
      # Export modules for reuse in other projects
      flake.modules = {
        nixos-configurations = ./modules/flake/nixos-configurations.nix;
      # Export modules organized by class for reuse in other projects
      flake.modules = {
        generic = {
          nixos-configurations = ./modules/flake/nixos-configurations.nix;
          overlays = ./modules/flake/overlays.nix;
          formatter = ./modules/flake/formatter.nix;
          packages = ./modules/flake/packages.nix;
          dev-shells = ./modules/flake/dev-shells.nix;
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

**Key changes:**
- Added `flake-parts` input
- Replaced direct output definition with `mkFlake`
- Moved outputs to separate modules in `modules/flake/`
- Added `systems` list for multi-platform support
- Configuration is now modular and importable
- Modules are exported via `flake.modules` organized by class (generic, nixosModules, homeModules)

#### New Files Created

##### `modules/flake/nixos-configurations.nix`
Contains the `nixosConfigurations` output. Extracted from main `flake.nix`.

##### `modules/flake/overlays.nix`
Defines nixpkgs overlays. Previously inline in main flake.

##### `modules/flake/formatter.nix`
Defines the default formatter (`alejandra`). New functionality!

##### `modules/flake/packages.nix`
Defines custom packages:
- `nixos-rebuild-switch` - Helper script for rebuilding
- `update-flake` - Helper script for updating inputs
- `clean-generations` - Helper script for cleanup

##### `modules/flake/dev-shells.nix`
Defines development environments:
- `default` - Full development environment with linters and tools
- `minimal` - Minimal environment for quick checks

## New Features

### 1. Code Formatting
```bash
# Format all Nix files
nix fmt
```

### 2. Development Shells
```bash
# Enter full development environment
nix develop

# Enter minimal environment
nix develop .#minimal
```

### 3. Custom Packages
```bash
# Build helper scripts
nix build .#nixos-rebuild-switch
nix build .#update-flake
nix build .#clean-generations

# List all packages
nix flake show
```

### 4. Better Organization
- Clear separation of concerns
- Each output type has its own module
- Easy to add new outputs
- Better documentation

## Breaking Changes

### None! 🎉

The migration is **backwards compatible**. All existing functionality works exactly as before:

```bash
# These commands still work
sudo nixos-rebuild switch --flake .#default
nix flake check
nix flake update
```

## Benefits of the New Structure

### 1. Modularity
Each output type is in its own file, making the codebase easier to navigate and understand.

### 2. Reusability
Flake-parts modules can be shared across multiple flakes:
```nix
# In another flake
{
  inputs.my-dotfiles.url = "github:deepzS2/dotfiles";
  
  outputs = {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        my-dotfiles.modules.overlays
      ];
    };
}
```

### 3. Scalability
Adding new outputs is simple - just create a new module:
```bash
# Add new module
echo '{ ... }: { perSystem = { ... }: { apps = { ... }; }; }' > modules/flake/apps.nix

# Import in flake.nix
# imports = [ ... ./modules/flake/apps.nix ];
```

### 4. Consistency
All modules follow the same pattern, making the codebase more predictable.

### 5. Type Safety
flake-parts provides better error messages for misconfigurations.

## Migration Checklist

If you're maintaining a fork or using this config as a base:

- [x] Add `flake-parts` to inputs
- [x] Create `modules/flake/` directory
- [x] Split outputs into separate modules
- [x] Update main `flake.nix` to use `mkFlake`
- [x] Test that everything still works
- [x] Update documentation
- [ ] Update your local flake.lock: `nix flake update`

## How to Use the New Structure

### Adding a New System Configuration

Edit `modules/flake/nixos-configurations.nix`:
```nix
{
  flake.nixosConfigurations = {
    default = withSystem "x86_64-linux" ({ ... }: ...);
    
    # Add new configuration
    laptop = withSystem "x86_64-linux" ({system, ...}:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs system;};
        modules = [../hosts/laptop/configuration.nix];
      }
    );
  };
}
```

### Adding a New Overlay

Edit `modules/flake/overlays.nix`:
```nix
{
  flake.overlays = {
    vscode-extensions = ...;
    
    # Add new overlay
    my-overlay = final: prev: {
      mypackage = prev.mypackage.overrideAttrs (old: {
        # modifications
      });
    };
    
    # Combine all overlays
    default = inputs.nixpkgs.lib.composeManyExtensions [
      inputs.nix-vscode-extensions.overlays.default
      self.overlays.my-overlay
    ];
  };
}
```

### Adding a New Package

Edit `modules/flake/packages.nix`:
```nix
{
  perSystem = {pkgs, ...}: {
    packages = {
      # Add new package
      my-tool = pkgs.writeShellScriptBin "my-tool" ''
        echo "My custom tool"
      '';
    };
  };
}
```

Build it:
```bash
nix build .#my-tool
```

### Adding a New Dev Shell

Edit `modules/flake/dev-shells.nix`:
```nix
{
  perSystem = {pkgs, ...}: {
    devShells = {
      # Add new shell
      rust-dev = pkgs.mkShell {
        packages = with pkgs; [
          rustc
          cargo
          rust-analyzer
        ];
      };
    };
  };
}
```

Use it:
```bash
nix develop .#rust-dev
```

## Troubleshooting

### Error: "attribute 'flake-parts' missing"

You need to update your flake.lock:
```bash
nix flake lock
```

### Error: "infinite recursion"

Check for circular dependencies in your modules. Make sure modules don't import each other in a loop.

### Commands Not Working

Make sure you're in the repository root:
```bash
cd /path/to/dotfiles
nix flake show
```

### Want to Revert?

The git history contains the original flake. You can always revert:
```bash
# See what changed
git log --oneline

# Revert to a specific commit
git revert <commit-hash>
```

## Next Steps

1. **Explore the documentation**
   - Read [README.md](./README.md) for an overview
   - Read [FLAKE_PARTS_GUIDE.md](./FLAKE_PARTS_GUIDE.md) for deep dive

2. **Try the new features**
   ```bash
   nix develop
   nix fmt
   nix build .#nixos-rebuild-switch
   ```

3. **Customize for your needs**
   - Add your own packages
   - Create custom dev shells
   - Define additional overlays

4. **Share your improvements**
   - The modular structure makes it easy to share modules
   - Consider publishing your modules for others to use

## Questions?

Refer to:
- [flake-parts documentation](https://flake.modules/flake/)
- [FLAKE_PARTS_GUIDE.md](./FLAKE_PARTS_GUIDE.md) in this repo
- [NixOS Discourse](https://discourse.nixos.org/)
- Open an issue in this repository

## Summary

This migration makes the NixOS configuration:
- ✅ More modular and organized
- ✅ Easier to maintain and extend
- ✅ Better documented
- ✅ Fully backwards compatible
- ✅ Ready for future growth

Happy Nix hacking! 🚀

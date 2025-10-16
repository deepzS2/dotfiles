# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added - Flake-parts Migration

#### New Directory Structure
- **`parts/`** - New directory for flake-parts modules
  - `nixos-configurations.nix` - NixOS system configurations
  - `overlays.nix` - Nixpkgs overlays
  - `formatter.nix` - Code formatter (alejandra)
  - `packages.nix` - Custom packages and helper scripts
  - `dev-shells.nix` - Development environments

#### New Documentation
- **`README.md`** - Comprehensive project overview
  - Quick start guide
  - Repository structure documentation
  - Configuration examples
  - Maintenance commands
  - Feature overview
- **`FLAKE_PARTS_GUIDE.md`** - In-depth flake-parts guide
  - Architecture explanation
  - Module system documentation
  - Dendritic Pattern overview
  - Best practices
  - Troubleshooting guide
- **`MIGRATION.md`** - Migration guide
  - Before/after comparisons
  - Breaking changes (none!)
  - New features explanation
  - Step-by-step migration checklist
- **`QUICKREF.md`** - Quick reference card
  - Common commands
  - System management
  - Flake operations
  - Development workflows
  - Troubleshooting tips
- **`CHANGELOG.md`** - This file!

#### New Features
- **Code Formatting** - Run `nix fmt` to format all Nix files
- **Development Shells**
  - `nix develop` - Full development environment with linters and tools
  - `nix develop .#minimal` - Minimal environment for quick checks
- **Custom Packages**
  - `nixos-rebuild-switch` - Helper script for system rebuilds
  - `update-flake` - Helper script for updating flake inputs
  - `clean-generations` - Helper script for garbage collection

#### Configuration Files
- **`.gitignore`** - Ignore build artifacts and editor files

### Changed

#### `flake.nix`
- **BREAKING**: Added `flake-parts` input
- **Changed**: Restructured to use `flake-parts.lib.mkFlake`
- **Changed**: Moved output definitions to separate modules
- **Added**: `systems` list for multi-platform support
- **Improved**: More modular and maintainable structure

**Impact**: All existing commands continue to work. No user-facing breaking changes.

#### Extracted Configurations
The following configurations were extracted from `flake.nix` into separate modules:

1. **NixOS Configurations** → `parts/nixos-configurations.nix`
   - Maintains all existing functionality
   - Uses `withSystem` for proper system handling
   - Includes all global Nix settings

2. **Overlays** → `parts/overlays.nix`
   - VSCode extensions overlay
   - Ready for additional overlays

3. **Formatter** → `parts/formatter.nix`
   - New functionality: `nix fmt` support
   - Uses alejandra formatter

### Technical Details

#### Module Pattern
All flake-parts modules follow this structure:
```nix
{
  inputs,
  withSystem,  # Optional, for flake-level outputs
  ...
}: {
  # Flake-level outputs
  flake.someOutput = { ... };
  
  # Per-system outputs
  perSystem = {pkgs, system, ...}: {
    packages = { ... };
    devShells = { ... };
    formatter = ...;
  };
}
```

#### Benefits
1. **Modularity** - Each output type in its own file
2. **Reusability** - Modules can be shared across flakes
3. **Scalability** - Easy to add new outputs
4. **Maintainability** - Clear separation of concerns
5. **Documentation** - Better organized and documented

#### Backwards Compatibility
All existing functionality is preserved:
- ✅ `sudo nixos-rebuild switch --flake .#default`
- ✅ `home-manager switch --flake .#deepz@default`
- ✅ `nix flake check`
- ✅ `nix flake update`
- ✅ All module enables/disables work as before

### Migration Notes

This refactoring is **fully backwards compatible**. Users need only:
1. Update `flake.lock` to include flake-parts: `nix flake update`
2. Enjoy the improved structure!

No configuration changes are required in:
- `hosts/` - All host configurations work as-is
- `modules/` - All modules work as-is
- `overlays/` - All overlays work as-is
- `config/` - All application configs work as-is

## Version History

### Before flake-parts
- Traditional Nix flake with all outputs in `flake.nix`
- Working NixOS configuration with home-manager
- Modular system and home-manager modules
- Multiple inputs: nixpkgs, home-manager, stylix, etc.

### After flake-parts (This Release)
- Modular flake structure using flake-parts
- Organized outputs in `parts/` directory
- Comprehensive documentation
- Development tooling (shells, formatter)
- Custom helper packages
- Better maintainability and scalability

## Future Enhancements

Potential additions for future releases:

### Planned
- [ ] Additional system configurations (laptop, server)
- [ ] More helper packages
- [ ] Custom overlays for specific use cases
- [ ] Integration tests
- [ ] CI/CD pipeline

### Under Consideration
- [ ] flake-parts modules for external consumption
- [ ] Additional development shells (rust, go, js)
- [ ] Custom deployment scripts
- [ ] Automated backup solutions
- [ ] Home-lab specific configurations

### Community Requests
- Open an issue to suggest features!

## Acknowledgments

This refactoring follows best practices from:
- [flake-parts documentation](https://flake.parts/)
- [Nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/)
- [NixOS community patterns](https://nixos.wiki/)
- Dendritic Pattern philosophy

## Contributing

When adding new features:
1. Follow the existing module pattern
2. Add documentation
3. Update relevant guides
4. Test thoroughly
5. Update this CHANGELOG

## Questions?

- See [README.md](./README.md) for overview
- See [QUICKREF.md](./QUICKREF.md) for commands
- See [FLAKE_PARTS_GUIDE.md](./FLAKE_PARTS_GUIDE.md) for details
- See [MIGRATION.md](./MIGRATION.md) for migration info
- Open an issue for help

---

**Note**: This is a living document. Updates will be added as the configuration evolves.

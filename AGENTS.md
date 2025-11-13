# Agent Guidelines for deepzS2's NixOS Dotfiles

## Build/Lint/Test Commands

### Development Shell

Enter with: `nix develop`

### Formatting & Linting

- **Format Nix**: `nix fmt` or `format` (in dev shell)
- **Lint Nix**: `statix check . && deadnix .` or `lint` (in dev shell)
- **Validate flake**: `nix flake check`

### Testing

- **Test single host**: `nh os test -H <hostname>` or `test <hostname>` (in dev shell)
- **Build VM**: `nh os build-vm -H <hostname>` or `build-vm <hostname>` (in dev shell)
- **Switch to config**: `nh os switch -H <hostname>` or `switch <hostname>` (in dev shell)

## Code Style Guidelines

### Nix Code Style

- **Formatter**: alejandra (configured in flake)
- **Linter**: statix for static analysis
- **Unused code**: deadnix to find/remove unused code
- **Naming**: kebab-case for files, camelCase for attributes
- **Options**: Use `lib.mkOption` with proper `type` and `description`
- **Imports**: Follow dendritic pattern with `flake.modules.*` structure
- **Error handling**: Standard Nix/Home Manager error propagation

### Lua Code Style (Neovim config)

- **Formatter**: stylua with config in `assets/nvim/.stylua.toml`
- **Indentation**: 2 spaces
- **Line width**: 160 columns
- **Quotes**: AutoPreferSingle
- **Line endings**: Unix
- **Call parentheses**: None (minimal parentheses)
- **Naming**: camelCase for variables/functions, kebab-case for files
- **Tables**: Use consistent formatting with proper indentation

### General Guidelines

- **Modules**: Follow dendritic pattern - single feature per module spanning multiple classes
- **Imports**: Auto-discovered via import-tree, no manual registration needed
- **Documentation**: Include descriptions for all options and configurations
- **Security**: Never commit secrets or keys to repository (use agenix for secrets)
- **Testing**: Always test configuration changes before committing


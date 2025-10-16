# Quick Reference Card

Quick reference for common operations with this NixOS configuration.

## 🚀 System Management

### Build and Switch
```bash
# Apply configuration changes
sudo nixos-rebuild switch --flake .#default

# Test configuration without switching
sudo nixos-rebuild test --flake .#default

# Build configuration without activating
sudo nixos-rebuild build --flake .#default

# Build VM for testing
sudo nixos-rebuild build-vm --flake .#default
```

### Using Helper Scripts
```bash
# Build the helper scripts first
nix build .#nixos-rebuild-switch
nix build .#update-flake
nix build .#clean-generations

# Then run them
./result/bin/nixos-rebuild-switch
./result/bin/update-flake
./result/bin/clean-generations 7  # days
```

## 🏠 Home Manager

```bash
# Switch home configuration
home-manager switch --flake .#deepz@default

# Build without switching
home-manager build --flake .#deepz@default
```

## 🔄 Flake Management

### Update
```bash
# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
nix flake lock --update-input home-manager

# Show what changed
git diff flake.lock
```

### Information
```bash
# Show flake outputs
nix flake show

# Show flake metadata
nix flake metadata

# Validate flake
nix flake check

# Validate with verbose output
nix flake check --show-trace
```

## 💻 Development

### Development Shells
```bash
# Enter default dev shell
nix develop

# Enter minimal dev shell
nix develop .#minimal

# Run command in dev shell
nix develop --command alejandra .
```

### Formatting
```bash
# Format all Nix files
nix fmt

# Format specific directory
nix fmt ./modules
```

### Linting
```bash
# Check for issues (requires dev shell)
nix develop --command statix check .

# Find dead code (requires dev shell)
nix develop --command deadnix .
```

## 📦 Packages

### Build Packages
```bash
# Build specific package
nix build .#nixos-rebuild-switch

# Build default package
nix build

# List all packages
nix search --json . | jq 'keys'
```

### Run Packages
```bash
# Run without installing
nix run .#nixos-rebuild-switch

# Run from GitHub (without cloning)
nix run github:deepzS2/dotfiles#clean-generations
```

## 🗑️ Cleanup

### Garbage Collection
```bash
# Delete old generations (7 days)
sudo nix-collect-garbage --delete-older-than 7d

# Delete all old generations
sudo nix-collect-garbage --delete-old

# Optimize nix store
nix-store --gc
nix-store --optimise
```

### Clean Boot Entries
```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Delete specific generation
sudo nix-env --delete-generations 10 --profile /nix/var/nix/profiles/system

# Rebuild boot menu
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot
```

## 🔍 Inspection

### System Information
```bash
# Show system configuration
nixos-option system.stateVersion

# Show package info
nix-env -qa | grep <package>

# Show package details
nix search nixpkgs <package>
```

### Evaluation
```bash
# Evaluate specific option
nix eval .#nixosConfigurations.default.config.networking.hostName

# Show configuration tree
nix repl
> :lf .
> nixosConfigurations.default.config.networking
```

## 🛠️ Troubleshooting

### Fix Issues
```bash
# Verbose build
nix build --show-trace --verbose

# Debug evaluation
nix eval --show-trace .#nixosConfigurations.default

# Check for errors in specific file
nix-instantiate --parse <file.nix>
```

### Rollback
```bash
# Boot into previous generation
# At boot, select previous generation from boot menu

# Rollback after bad switch
sudo nixos-rebuild switch --rollback

# List available generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

## 📝 Module Management

### Enable/Disable Modules

Edit `hosts/default/home.nix`:
```nix
{
  # Enable modules
  git.enable = true;
  applications.browser.enable = true;
  
  # Disable modules
  applications.discord.enable = false;
}
```

Then apply:
```bash
home-manager switch --flake .#deepz@default
```

### Add New Module

1. Create module file in appropriate location:
   ```bash
   # NixOS module
   touch modules/nixos/my-module.nix
   
   # Home Manager module
   touch modules/home-manager/my-module.nix
   ```

2. Add to default.nix in the same directory:
   ```nix
   {
     imports = [
       ./existing-module.nix
       ./my-module.nix  # Add this
     ];
   }
   ```

3. Use in configuration:
   ```nix
   # hosts/default/configuration.nix or home.nix
   {
     my-module.enable = true;
   }
   ```

## 🔐 Secrets Management

### Using agenix
```bash
# Edit secret
agenix -e secrets/my-secret.age

# Rekey secrets
agenix -r

# List secrets
agenix -l
```

## 📊 Performance

### Build Performance
```bash
# Parallel builds
nix build --max-jobs auto

# Use more cores
nix build --cores 0

# Show build stats
nix build --print-build-logs
```

### Store Optimization
```bash
# Show store size
du -sh /nix/store

# Find large paths
nix path-info --all --size | sort -n -k2 | tail -20

# Why is package in store?
nix-store --query --roots /nix/store/<hash>-package
```

## 🎯 Useful Aliases

Add to your shell config:
```bash
# NixOS
alias nrs="sudo nixos-rebuild switch --flake .#default"
alias nrb="sudo nixos-rebuild build --flake .#default"
alias nrt="sudo nixos-rebuild test --flake .#default"

# Home Manager
alias hms="home-manager switch --flake .#deepz@default"
alias hmb="home-manager build --flake .#deepz@default"

# Flake
alias nfu="nix flake update"
alias nfc="nix flake check"
alias nfs="nix flake show"

# Cleanup
alias ngc="sudo nix-collect-garbage --delete-older-than 7d"
alias nstore="du -sh /nix/store"
```

## 💡 Tips

- **Use `nix develop`** for a consistent dev environment
- **Format before commit** with `nix fmt`
- **Test in VM** before applying to system
- **Keep flake.lock in git** for reproducibility
- **Document custom modules** for future you
- **Backup before major changes** with `nixos-rebuild build`
- **Use `--show-trace`** for debugging
- **Check discourse/wiki** when stuck

## 📚 More Help

- Run `nix --help` for command help
- Visit [FLAKE_PARTS_GUIDE.md](./FLAKE_PARTS_GUIDE.md) for architecture details
- See [MIGRATION.md](./MIGRATION.md) for migration info
- Check [README.md](./README.md) for full documentation

---

**Pro tip:** Keep this file open in a split terminal for quick reference! 🚀

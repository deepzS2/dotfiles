# Packages module for flake-parts
# This module defines custom packages that can be built with `nix build`
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
      # Example: Create a helper script for managing the configuration
      nixos-rebuild-switch = pkgs.writeShellScriptBin "nixos-rebuild-switch" ''
        #!/usr/bin/env bash
        set -euo pipefail
        
        echo "Building and switching to new NixOS configuration..."
        sudo nixos-rebuild switch --flake .#default
        echo "Configuration applied successfully!"
      '';

      # Example: Script to update flake inputs
      update-flake = pkgs.writeShellScriptBin "update-flake" ''
        #!/usr/bin/env bash
        set -euo pipefail
        
        echo "Updating flake inputs..."
        nix flake update
        echo "Inputs updated! Review with 'git diff flake.lock'"
      '';

      # Example: Script to clean old generations
      clean-generations = pkgs.writeShellScriptBin "clean-generations" ''
        #!/usr/bin/env bash
        set -euo pipefail
        
        DAYS=''${1:-7}
        echo "Cleaning generations older than $DAYS days..."
        sudo nix-collect-garbage --delete-older-than "''${DAYS}d"
        echo "Cleanup complete!"
      '';
    };
  };
}

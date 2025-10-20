# Development shells module for flake-parts
# This module defines development environments accessible with `nix develop`
_: {
  perSystem = {
    pkgs,
    ...
  }: {
    devShells = {
      # Default development shell for working on this configuration
      default = pkgs.mkShell {
        name = "nixos-config-dev";
        
        packages = with pkgs; [
          # Nix tools
          alejandra    # Nix formatter
          nil          # Nix LSP
          statix       # Nix linter
          deadnix      # Find dead code
          
          # Version control
          git
          
          # Utilities
          jq           # JSON processor
          yq           # YAML processor
          tree         # Directory visualization
        ];
        
        shellHook = ''
          echo "╔════════════════════════════════════════════════════════╗"
          echo "║   NixOS Configuration Development Environment         ║"
          echo "╚════════════════════════════════════════════════════════╝"
          echo ""
          echo "Available commands:"
          echo "  nix fmt              - Format all Nix files"
          echo "  nix flake check      - Validate flake configuration"
          echo "  nix flake update     - Update all inputs"
          echo "  statix check .       - Lint Nix files for issues"
          echo "  deadnix .            - Find unused Nix code"
          echo ""
          echo "Build and test:"
          echo "  nixos-rebuild build-vm --flake .#default"
          echo "  nixos-rebuild test --flake .#default"
          echo ""
          echo "Documentation:"
          echo "  README.md              - Project overview"
          echo "  FLAKE_PARTS_GUIDE.md   - Detailed flake-parts guide"
          echo ""
        '';
      };
      
      # Minimal shell for quick checks
      minimal = pkgs.mkShell {
        name = "nixos-config-minimal";
        
        packages = with pkgs; [
          alejandra
          nil
        ];
        
        shellHook = ''
          echo "Minimal NixOS config environment loaded"
        '';
      };
    };
  };
}

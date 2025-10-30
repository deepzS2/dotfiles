{...}: {
  perSystem = {pkgs, ...}: {
    devShells = {
      # Default development shell for working on this configuration
      default = pkgs.mkShell {
        name = "nixos-config-dev";

        packages = with pkgs; [
          # Nix tools
          alejandra # Nix formatter
          nil # Nix LSP
          statix # Nix linter
          deadnix # Find dead code

          # Version control
          git

          # Utilities
          jq # JSON processor
          yq # YAML processor
          tree # Directory visualization
        ];

        shellHook = ''
          NH_FLAKE="$PWD"
          alias lint="statix check $PWD && deadnix $PWD"
          alias format="nix fmt $PWD"

          has_staged_changes() {
            UNSTAGED_FILES=$(git status --porcelain | grep -E '^[ MADRCU][MADRCU]|^.[D]')

            if [ -z "$UNSTAGED_FILES" ]; then
              return 0
            else
              echo "🚨 WARNING: You have unstaged changes in your working directory."
              echo "   Please run 'git add <file>...' or 'git add .' to stage them."
              return 1
            fi
          }

          test() {
            if has_staged_changes; then
              nh os test -H $1
            fi
          }

          build-vm() {
            if has_staged_changes; then
              nh os build-vm -H $1
            fi
          }

          switch() {
            if has_staged_changes; then
              nh os switch -H $1
            fi
          }

          echo "╔════════════════════════════════════════════════════════╗"
          echo "║   NixOS Configuration Development Environment          ║"
          echo "╚════════════════════════════════════════════════════════╝"
          echo ""
          echo "Available commands:"
          echo "  format               - Format all Nix files"
          echo "  nix flake check      - Validate flake configuration"
          echo "  nix flake update     - Update all inputs"
          echo "  lint                 - Lint Nix files for issues and unused code"
          echo ""
          echo "Build and test:"
          echo "  build-vm <hostname>  - Build a VM Image"
          echo "  test <hostname>      - Test current flake configuration"
          echo "  switch <hostname>    - Rebuild and switch to the new generation"
          echo ""
        '';
      };
    };
  };
}

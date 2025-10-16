# Overlays module for flake-parts
# This module defines nixpkgs overlays
{inputs, ...}: {
  flake.overlays = {
    # VSCode extensions overlay
    vscode-extensions = inputs.nix-vscode-extensions.overlays.default;

    # Default overlay that combines all overlays
    default = inputs.nix-vscode-extensions.overlays.default;
  };
}

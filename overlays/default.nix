# ./overlays/default.nix
{inputs, ...}: {
  # VSCode overlay
  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];
}

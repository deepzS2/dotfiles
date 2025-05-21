{ ... }: {
  imports = [
    ./browser.nix
    ./terminal.nix
    ./editor.nix
    ./shell.nix
    ./git.nix
    ./window-manager.nix
  ];
}
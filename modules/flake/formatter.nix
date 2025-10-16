# Formatter module for flake-parts
# This module defines the default formatter for nix fmt
{
  inputs,
  withSystem,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    # Use alejandra as the default formatter
    formatter = pkgs.alejandra;
  };
}

# Formatter module for flake-parts
# This module defines the default formatter for nix fmt
# Exported as flake.modules.generic.formatter
{
  perSystem = {
    pkgs,
    ...
  }: {
    # Use alejandra as the default formatter
    formatter = pkgs.alejandra;
  };
}

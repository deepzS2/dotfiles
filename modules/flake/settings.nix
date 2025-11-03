{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) enum;
in {
  # These are flake level options that NEED to be set by either a preset or a host.
  options.flake.settings = {
    window-manager = mkOption {
      description = "The window manager to be used";
      default = "niri";
      type = enum ["niri" "hyprland"];
    };
  };
}

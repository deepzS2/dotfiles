{lib, ...}: let
  wmOption = {
    options.window-manager = lib.mkOption {
      description = "The window manager to be used";
      default = "niri";
      example = "hyprland";
      type = lib.types.enum ["niri" "hyprland" "mango"];
    };
  };
in {
  flake.modules.nixos.core = wmOption;
  flake.modules.homeManager.core = wmOption;
}

{lib, ...}: let
  wmOption = {
    options.settings.wm = lib.mkOption {
      description = "The window manager to be used";
      default = "niri";
      example = "hyprland";
      type = lib.types.enum ["niri" "hyprland" "mango"];
    };
  };
in {
  flake.modules.nixos.options = wmOption;
  flake.modules.homeManager.options = wmOption;
}

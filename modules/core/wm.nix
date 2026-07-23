{
  flake.modules.nixos.core = {lib, ...}: {
    options.window-manager = lib.mkOption {
      description = "The window manager to be used";
      default = "niri";
      example = "hyprland";
      type = lib.types.enum ["niri" "hyprland" "mango"];
    };
  };

  flake.modules.hjem.core = {lib, ...}: {
    options.window-manager = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Active window manager for this user.";
    };
  };
}

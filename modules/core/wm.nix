{
  flake.modules.nixos.core = {lib, ...}: {
    options.window-manager = lib.mkOption {
      description = "The window manager to be used";
      default = "mango";
      example = "niri";
      type = lib.types.enum ["niri" "mango"];
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

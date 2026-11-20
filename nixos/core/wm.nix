{lib, ...}: {
  options.window-manager = lib.mkOption {
    description = "The window manager to be used";
    default = "mango";
    example = "niri";
    type = lib.types.enum ["niri" "mango"];
  };
}

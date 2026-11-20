{lib, ...}: {
  options.window-manager = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Active window manager for this user.";
  };
}

{ lib, config, ...}:
  let 
    cfg = config.window-manager;
  in {
    options = {
      window-manager.enable = lib.mkEnableOption "Window Manager";
    };

    config = lib.mkIf cfg.enable {
      programs.kitty.enable = true; # required for the default Hyprland config
      wayland.windowManager.hyprland = {
        enable = true;
      };
    };
  }
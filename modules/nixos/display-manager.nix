{...}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # SDDM Greeter
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Enables Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
}

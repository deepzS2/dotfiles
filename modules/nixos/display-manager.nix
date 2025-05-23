{...}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager = {
    # Enable automatic login for the user.
    autoLogin = {
      enable = true;
      user = "deepz";
    };

    sddm = {
      enable = true;
      wayland.enable = true;
      settings = {
        Autologin = {
          Session = "Hyprland";
          User = "deepz";
        };
        General = {
          DisplayServer = "wayland";
        };
      };
    };
  };

  # Enables Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
}

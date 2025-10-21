# Display manager and Hyprland configuration module for NixOS
# Exported as flake.modules.nixosModules.display-manager
{
  flake.modules.nixos.display-manager = {pkgs, ...}: let
    sddm-astronaut-theme = pkgs.sddm-astronaut.override {
      embeddedTheme = "pixel_sakura";
    };
  in {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # SDDM Greeter
    services.displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      theme = "${sddm-astronaut-theme}/share/sddm/themes/sddm-astronaut-theme";
      extraPackages = [
        sddm-astronaut-theme
      ];
    };

    # Enables Hyprland
    programs.hyprland = {
      enable = true;
      withUWSM = true; # recommended for most users
      xwayland.enable = true; # Xwayland can be disabled.
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
    environment.systemPackages = with pkgs; [
      nautilus
    ];
  };
}

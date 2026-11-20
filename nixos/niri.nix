{
  inputs,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [inputs.niri.overlays.niri];

  window-manager = lib.mkDefault "niri";

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  environment.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
    NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
  };
}

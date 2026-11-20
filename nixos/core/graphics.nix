{
  pkgs,
  lib,
  ...
}: {
  hardware.graphics = let
    essentialPackages = [
      pkgs.libva
      pkgs.libva-utils
      pkgs.vulkan-loader
      pkgs.libGL
      pkgs.libGLU # for very old pre-2005 OpenGL games
    ];
  in {
    enable = true;
    enable32Bit = true;
    extraPackages = lib.mkDefault essentialPackages;
    extraPackages32 = lib.mkDefault essentialPackages;
  };
}

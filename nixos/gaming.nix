{pkgs, ...}: {
  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true; # Microcompositor for performance and improve visuals (HDR, Stretched Res, Upscaling, etc.)
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) mangohud protonup-qt lutris bottles heroic prismlauncher;
  };
}

{
  flake.modules.nixos.gaming = {pkgs, ...}: {
    programs.gamemode.enable = true; # Performance mode
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Steam Remote Play ports
      dedicatedServer.openFirewall = true; # Source Dedicated Server ports
      gamescopeSession.enable = true; # Microcompositor for performance and improve visuals (HDR, Stretched Res, Upscaling, etc.)
    };

    environment.systemPackages = with pkgs; [
      mangohud
      protonup-qt
      lutris
      bottles
      heroic
      prismlauncher
    ];
  };
}

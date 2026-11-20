{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.audio;
in {
  options.audio = {
    bluetooth.enable = lib.mkEnableOption "Enable bluetooth services";
  };

  config = {
    environment.systemPackages = [pkgs.pipewire.jack];

    security.rtkit.enable = true;

    services = {
      pulseaudio.enable = false;

      pipewire = {
        enable = true;

        alsa.enable = true;
        alsa.support32Bit = true;

        pulse.enable = true;
        wireplumber.enable = true;
      };
    };

    hardware.bluetooth.enable = cfg.bluetooth.enable;
    services.blueman.enable = cfg.bluetooth.enable;
  };
}

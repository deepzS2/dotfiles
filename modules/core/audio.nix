{
  flake.modules.nixos.core = {
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

      # Audio with pipewire.
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

      # Bluetooth
      hardware.bluetooth.enable = cfg.bluetooth.enable;
      services.blueman.enable = cfg.bluetooth.enable;
    };
  };
}

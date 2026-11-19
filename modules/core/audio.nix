{
  flake.modules.nixos.core = {pkgs, ...}: {
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
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}

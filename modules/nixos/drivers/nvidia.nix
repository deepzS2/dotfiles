{
  flake.modules.nixosModules.drivers-nvidia = {
    pkgs,
    config,
    ...
  }: {
    # Enable NVIDIA proprietary drivers
    services.xserver.videoDrivers = ["nvidia"];

    # Hardware acceleration and graphics support
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
        vdpauinfo
        libva
        libva-utils
      ];
    };

    # NVIDIA driver configuration
    hardware.nvidia = {
      # Modesetting is required for most wayland compositors
      modesetting.enable = true;
      
      # Power management (experimental, can cause sleep/suspend issues)
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      
      # NVIDIA persistence daemon
      nvidiaPersistenced = false;
      
      # Use proprietary driver (open = false) or open-source (open = true)
      open = false;
      
      # Enable nvidia-settings GUI
      nvidiaSettings = true;
      
      # Use latest driver version
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };
}

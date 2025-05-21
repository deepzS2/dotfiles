{ ... }:
  {
    networking = {
      hostName = "alan"; # Define your hostname.
      # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # proxy.default = "http://user:password@proxy:port/";
      # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      networkmanager.enable = true; # Enable networking
    };

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  }
{
  flake.modules.nixos.core = {
    config,
    lib,
    ...
  }: let
    cfg = config.network;
  in {
    options.network = {
      wireless.enable = lib.mkEnableOption "Enable wireless support via wpa_supplicant";
      hostName = lib.mkOption {
        type = lib.types.str;
        example = "deepz";
      };
    };

    config = {
      networking = {
        inherit (cfg) hostName;

        wireless.enable = lib.mkForce cfg.wireless.enable;
        networkmanager.enable = true;

        firewall = {
          enable = true;
          allowedTCPPorts = [8080];
          allowedUDPPorts = [];
        };
      };
    };
  };
}

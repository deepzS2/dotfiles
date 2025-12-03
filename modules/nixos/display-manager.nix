{
  inputs,
  config,
  ...
}: let
  inherit (config.flake.assets) media;
in {
  flake.modules.nixos.display-manager = {pkgs, ...}: let
    bg = pkgs.fetchurl {
      url = "https://www.desktophut.com/files/0wy7pescJl-YakuzaMajimaGoroTattooLiveWallpaper.mp4";
      hash = "sha256-bKEwQQvhPnnwS/OOsqTx6BKJ74tZtvWdj5HVvwKZThs=";
    };
    # an exhaustive example can be found in flake.nix
    sddm-theme = inputs.silentSDDM.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      theme = "rei"; # select the config of your choice
      extraBackgrounds = [bg];
      theme-overrides = {
        "LoginScreen" = {
          background = "${bg.name}";
        };
        "LockScreen" = {
          background = "${bg.name}";
        };
      };
    };
  in {
    environment.systemPackages = [sddm-theme sddm-theme.test];
    qt.enable = true;

    services = {
      # Enable the X11 windowing system.
      xserver.enable = true;

      # SDDM Greeter
      displayManager.defaultSession = "niri";
      displayManager.sddm = {
        package = pkgs.kdePackages.sddm; # use qt6 version of sddm
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
        theme = sddm-theme.pname;
        # the following changes will require sddm to be restarted to take
        # effect correctly. It is recomend to reboot after this
        extraPackages = sddm-theme.propagatedBuildInputs;
        settings = {
          # required for styling the virtual keyboard
          General = {
            GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
            InputMethod = "qtvirtualkeyboard";
          };
        };
      };
    };

    systemd.tmpfiles.rules = let
      user = "deepz";
      iconPath = "${media}/avatars/me.png";
    in [
      "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
      "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${iconPath}"
    ];
  };
}

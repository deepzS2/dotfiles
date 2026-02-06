{
  inputs,
  self,
  ...
}: let
  inherit (self) directories;

  mkNiriProgram = setting: package: {
    enable = setting == "niri";
    package = package;
  };
in {
  flake.modules.nixos.niri = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      inputs.niri.nixosModules.niri
    ];

    programs.niri = mkNiriProgram config.settings.wm pkgs.niri-unstable;

    environment = {
      sessionVariables = {
        GTK_IM_MODULE = "ibus";
        QT_IM_MODULE = "ibus";
        XMODIFIERS = "@im=ibus";
        NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
      };
      systemPackages = [pkgs.nautilus];
    };
  };

  flake.modules.homeManager.niriImport = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.settings) wm;
  in {
    config = lib.mkIf (wm == "niri") {
      imports = [
        inputs.niri.homeModules.niri
      ];

      programs.niri = mkNiriProgram config.settings.wm pkgs.niri-unstable;
    };
  };

  flake.modules.homeManager.niri = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.settings) wm;

    monitorsKdl = lib.concatStringsSep "\n" (map (monitor: ''
        output "${monitor.name}" {
            scale ${toString monitor.scale}
            mode "${toString monitor.width}x${toString monitor.height}@${toString monitor.refresh-rate}"
            position x=${toString monitor.x} y=${toString monitor.y}
        }
      '')
      config.settings.monitors);
  in {
    config = lib.mkIf (wm == "niri") {
      home = {
        packages = [
          inputs.sheez.packages.${pkgs.stdenv.hostPlatform.system}.default
          inputs.niri-scratchpad.packages.${pkgs.stdenv.hostPlatform.system}.default
          pkgs.xdg-desktop-portal-gnome
          pkgs.xwayland-satellite
          pkgs.ibus
        ];

        file = {
          ".config/niri/config.kdl".source = "${directories.config}/niri.kdl";
          ".config/niri/monitors.kdl".text = monitorsKdl;
        };

        pointerCursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 24;
          gtk.enable = true;
          x11.enable = true;
        };

        sessionVariables = {
          XCURSOR_THEME = "Bibata-Modern-Classic";
          XCURSOR_SIZE = "24";
        };
      };

      systemd.user.services.xwayland-satellite = {
        Unit = {
          Description = "Xwayland outside Wayland";
          BindsTo = "graphical-session.target";
          After = "graphical-session.target";
        };
        Service = {
          Type = "notify";
          NotifyAccess = "all";
          ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
          StandardOutput = "journal";
          Restart = "on-failure";
        };
      };
    };
  };
}

{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../nixos/mango.nix
    ../../nixos/amd.nix
    ../../nixos/nh.nix
    ../../nixos/fhs.nix
    ../../nixos/virtualisation.nix
    ../../nixos/gaming.nix
    ../../nixos/localsend.nix
    ../../nixos/portal.nix
    ../../nixos/obs.nix
  ];

  bootloader = {
    secure.enable = true;
    windows.enable = true;
  };

  network.hostName = "omi";

  system.stateVersion = "25.05";

  hardware.logitech.wireless.enable = true;
  services.ratbagd.enable = true;
  programs.solaar.enable = true;
  services.udev.packages = [pkgs.headsetcontrol];
  environment.systemPackages = [pkgs.piper pkgs.headsetcontrol pkgs.easyeffects];

  hjem.users.deepz = {
    imports = [
      ../../hjem/desktop/mango.nix
      ../../hjem/desktop/idle.nix
      ../../hjem/desktop/launcher.nix
      ../../hjem/desktop/scripts.nix
      ../../hjem/desktop/media.nix
      ../../hjem/desktop/terminal.nix
      ../../hjem/desktop/theme.nix

      ../../hjem/programs/ai.nix
      ../../hjem/programs/browser.nix
      ../../hjem/programs/btop.nix
      ../../hjem/programs/discord.nix
      ../../hjem/programs/drive.nix
      ../../hjem/programs/emacs.nix
      ../../hjem/programs/file-manager.nix
      ../../hjem/programs/git.nix
      ../../hjem/programs/music.nix
      ../../hjem/programs/nix-search.nix
      ../../hjem/programs/nushell.nix
      ../../hjem/programs/nvim.nix
      ../../hjem/programs/secrets.nix
      ../../hjem/programs/tmux.nix
      ../../hjem/programs/video-player.nix
      ../../hjem/programs/vscode.nix

      ../../hjem/dev/common.nix
      ../../hjem/dev/elixir.nix
      ../../hjem/dev/go.nix
      ../../hjem/dev/javascript.nix
      ../../hjem/dev/rust.nix

      ../../hjem/services/syncthing.nix
    ];

    idle = {
      lock = 600;
      dpms = 1200;
      suspend = null;
    };

    monitors = [
      {
        name = "DP-2";
        width = 1920;
        height = 1080;
        refresh-rate = 165.0;
        scale = 1.0;
        x = 0;
        y = 0;
        primary = true;
      }
      {
        name = "HDMI-A-1";
        width = 1920;
        height = 1080;
        refresh-rate = 75.0;
        scale = 1.0;
        x = -1920;
        y = 0;
        primary = false;
      }
    ];
  };
}

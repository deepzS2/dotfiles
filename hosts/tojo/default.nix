{...}: {
  imports = [
    ./hardware-configuration.nix

    ../../nixos/mango.nix
    ../../nixos/nvidia.nix
    ../../nixos/fhs.nix
    ../../nixos/virtualisation.nix
    ../../nixos/gaming.nix
    ../../nixos/nh.nix
    ../../nixos/obs.nix
    ../../nixos/localsend.nix
  ];

  bootloader = {
    secure.enable = true;
    windows.enable = true;
  };

  network = {
    hostName = "tojo";
    wireless.enable = true;
  };
  audio.bluetooth.enable = true;

  # GTX 1650 Turing
  hardware.graphics.nvidia = {
    open = true;
    prime = "offload";
    powerManagement.enable = true;

    busId = {
      amd = "PCI:5@0:0:0";
      nvidia = "PCI:1@0:0:0";
    };
  };

  services.upower.enable = true;
  powerManagement.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      TLP_AUTO_SWITCH = 1;
      TLP_PROFILE_AC = "PRF";
      TLP_PROFILE_BAT = "SAV";

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  system.stateVersion = "25.05";

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
      lock = 300;
      dpms = 330;
      suspend = 1800;
    };

    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
        refresh-rate = 144.0;
        scale = 1.0;
        x = 0;
        y = 0;
        primary = true;
      }
    ];
  };
}

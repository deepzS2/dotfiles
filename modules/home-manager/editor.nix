{ pkgs, lib, config, ... }:
  let 
    cfg = config.editor;
  in {
    options = {
      editor.enable = lib.mkEnableOption "editor";
    };

    config = lib.mkIf cfg.enable {
      home.packages = [
        # VSCode
        pkgs.vscode

        # Nix
        pkgs.nixd
        pkgs.alejandra

        # C compiler
        pkgs.gcc

        # Dashboard
        pkgs.dwt1-shell-color-scripts
      ];

      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      };

      home.file.".config/nvim" = {
        source = ../../config/nvim;
        recursive = true;
      };
    };
  }
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

      programs.nvf = {
        enable = true;
        
        settings = {
          vim = {
            viAlias = false;

            luaConfigRC.deepz = /* lua */ ''
              require 'deepz.core'
              require 'deepz.lazy'
            '';
          };
        };
      };

      home.file.".config/nvf" = {
        source = ../../config/nvim;
        recursive = true;
      };
    };
  }
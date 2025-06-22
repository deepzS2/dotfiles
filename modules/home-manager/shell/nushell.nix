{
  lib,
  config,
  ...
}: let
  cfg = config.shell.nushell;
in {
  options = {
    shell.nushell.enable = lib.mkEnableOption "Nushell";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nushell = {
        enable = true;

        settings = {
          show_banner = false;
          edit_mode = "vi";
        };

        extraConfig =
          lib.mkAfter
          /*
          nu
          */
          ''
            fastfetch
          '';
        shellAliases = {
          ll = "ls -l";
          la = "ls -a";
          cat = "bat";
        };
      };

      # Cat but with wings
      bat.enable = true;

      # Lazygit
      lazygit.enable = true;

      # Lazydocker
      lazydocker.enable = true;

      # Carapace autocompletion
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };

      # Better CD
      zoxide = {
        enable = true;
        enableNushellIntegration = true;
        options = ["--cmd cd"];
      };
    };
  };
}

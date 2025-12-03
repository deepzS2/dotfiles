# Nushell shell configuration module for Home Manager
# Exported as flake.modules.homeManager.nushell
{
  flake.modules.homeManager.nushell = {
    lib,
    config,
    ...
  }: {
    programs = {
      starship = {
        enable = true;
        enableNushellIntegration = true;
      };

      nushell = {
        enable = true;

        environmentVariables = {
          NH_FLAKE = "${config.home.homeDirectory}/.dotfiles";
        };

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

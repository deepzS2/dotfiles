# Nushell shell configuration module for Home Manager
# Exported as flake.modules.homeManager.nushell
{
  flake.modules.homeManager.nushell = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.shell.nushell;
    ns = pkgs.writeShellScriptBin "ns" (builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh");
  in {
    options = {
      shell.nushell.enable = lib.mkEnableOption "Nushell";
    };

    config = lib.mkIf cfg.enable {
      home.packages = [ns pkgs.fzf pkgs.nix-search-tv];

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
  };
}

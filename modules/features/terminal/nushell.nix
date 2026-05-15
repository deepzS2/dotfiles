{self, ...}: let
  inherit (self) directories;
in {
  flake.modules.homeManager.nushell = {
    pkgs,
    lib,
    config,
    ...
  }: {
    home.file.".config/nushell/autoload" = {
      source = "${directories.config}/nushell";
      recursive = true;
    };

    programs = {
      nushell = {
        enable = true;

        environmentVariables = {
          NH_FLAKE = "${config.home.homeDirectory}/.dotfiles";
          EDITOR = "nvim";
          GOOGLE_API_KEY = lib.hm.nushell.mkNushellInline ''bash -c "cat ${config.age.secrets.gemini_key.path}"'';
          BRAVE_API_KEY = lib.hm.nushell.mkNushellInline ''bash -c "cat ${config.age.secrets.brave_search.path}"'';
        };

        # The "Bridge" config
        configFile.text = let
          # Pre-generate init scripts at build time to avoid ~/ paths
          zoxideInit = pkgs.runCommand "zoxide.nu" {} ''
            ${lib.getExe pkgs.zoxide} init nushell --cmd cd >> "$out"
          '';
          starshipInit = pkgs.runCommand "starship.nu" {} ''
            ${lib.getExe pkgs.starship} init nu >> "$out"
          '';
          carapaceInit = pkgs.runCommand "carapace.nu" {} ''
            ${lib.getExe pkgs.carapace} _carapace nushell | sed 's|"/homeless-shelter|$"($env.HOME)|g' >> "$out"
          '';
        in
          /*
          nu
          */
          ''
            # Integration
            source ${zoxideInit}
            source ${carapaceInit}
            use ${starshipInit}

            $env.config.edit_mode = "vi"
            $env.config.show_banner = false

            if ($env.TMUX? | is-empty) {
              fastfetch
            }
          '';
      };

      # Prompt
      starship = {
        enable = true;
        enableNushellIntegration = false;
      };

      # Nix direnv + devshell = <3
      direnv = {
        enable = true;
        enableNushellIntegration = false;
        nix-direnv.enable = true;
      };

      # Cat but with wings
      bat.enable = true;

      # Lazygit
      lazygit = {
        enable = true;
        enableNushellIntegration = false;
      };

      # Lazydocker
      lazydocker.enable = true;

      # Carapace autocompletion
      carapace = {
        enable = true;
        enableNushellIntegration = false;
      };

      # Better CD
      zoxide = {
        enable = true;
        enableNushellIntegration = false;
      };
    };
  };
}

{
  lib,
  pkgs,
  self,
  config,
  ...
}: let
  zoxideInit = pkgs.runCommand "zoxide.nu" {} ''
    ${lib.getExe pkgs.zoxide} init nushell --cmd cd >> "$out"
  '';
  starshipInit = pkgs.runCommand "starship.nu" {} ''
    ${lib.getExe pkgs.starship} init nu >> "$out"
  '';
  carapaceInit = pkgs.runCommand "carapace.nu" {} ''
    ${lib.getExe pkgs.carapace} _carapace nushell | sed 's|"/homeless-shelter|$"($env.HOME)|g' >> "$out"
  '';
in {
  packages = [
    pkgs.yazi
    pkgs.starship
    pkgs.bat
    pkgs.lazydocker
    pkgs.carapace
    pkgs.zoxide
    pkgs.direnv
    pkgs.nushell
    pkgs.microfetch
    pkgs.ouch
  ];

  xdg.config.files = {
    "nushell/autoload".source = "${self}/config/nushell";
    "nushell/config.nu".text =
      # nu
      ''
        source ${zoxideInit}
        source ${carapaceInit}
        use ${starshipInit}

        $env.config.edit_mode = "vi"
        $env.config.show_banner = false

        if ($env.TMUX? | is-empty) {
          microfetch
        }
      '';

    "hjem/env.sh".source = config.environment.loadEnv;
    "nushell/env.nu".text =
      /*
      nu
      */
      ''
        let hjem_env = ("~/.config/hjem/env.sh" | path expand)
        if ($hjem_env | path exists) {
          open $hjem_env
          | lines
          | parse 'export {key}="{value}"'
          | reduce --fold {} {|it, acc| $acc | insert $it.key $it.value }
          | load-env
        }

        let secrets_file = ("~/.config/nushell/secrets.json" | path expand)
        if ($secrets_file | path exists) {
          open $secrets_file | load-env
        }
      '';
  };

  environment.sessionVariables = {
    NH_FLAKE = "${config.directory}/.dotfiles";
    EDITOR = "nvim";
  };
}

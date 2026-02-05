{config, ...}: let
  inherit (config.flake) assets;
in {
  flake.modules.homeManager.tmux = {pkgs, ...}: let
    ukiyoConfig = ''
      set -g @ukiyo-ignore-window-colors true
      set -g @ukiyo-show-powerline true
      set -g @ukiyo-show-flags true
      set -g @ukiyo-plugins "battery cpu-usage ram-usage weather time"

      set -g @ukiyo-cpu-usage-label "󰍛 "
      set -g @ukiyo-ram-usage-label " "

      set -g @ukiyo-show-timezone false
      set -g @ukiyo-day-month true

      set -g @ukiyo-show-fahrenheit false
      set -g @ukiyo-show-location false
      set -g @ukiyo-fixed-location "São Paulo"

      run-shell ${pkgs.tmuxPlugins.ukiyo}/share/tmux-plugins/ukiyo/ukiyo.tmux

      set -g @ukiyo-theme "kanagawa/wave"
      set -g @ukiyo-show-right-sep ""
      set -g @ukiyo-show-right-sep ""
    '';
  in {
    home = {
      packages = with pkgs; [
        tmux
        tmuxinator
        tmuxPlugins.continuum
        tmuxPlugins.pain-control
        tmuxPlugins.resurrect
        tmuxPlugins.sensible
        tmuxPlugins.sessionist
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.yank
      ];

      file.".config/tmux/plugins.conf".text = ''
          ${ukiyoConfig}

        run-shell ${pkgs.tmuxPlugins.pain-control}/share/tmux-plugins/pain-control/pain-control.tmux
        run-shell ${pkgs.tmuxPlugins.sensible}/share/tmux-plugins/sensible/sensible.tmux
        run-shell ${pkgs.tmuxPlugins.sessionist}/share/tmux-plugins/sessionist/sessionist.tmux
        run-shell ${pkgs.tmuxPlugins.vim-tmux-navigator}/share/tmux-plugins/vim-tmux-navigator/vim-tmux-navigator.tmux

        run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
        run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux
      '';

      file.".config/tmux/tmux.conf".source = "${assets.path}/tmux.conf";
    };
  };
}

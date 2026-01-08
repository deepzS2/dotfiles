{config, ...}: let
  inherit (config.flake) assets;
in {
  flake.modules.homeManager.tmux = {pkgs, ...}: let
    kanagawaConfig = ''
      set -g @kanagawa-theme 'wave'
      set -g @kanagawa-ignore-window-colors true
      set -g @kanagawa-show-powerline true
      set -g @kanagawa-show-flags true
      set -g @kanagawa-show-left-icon "smiley"
      set -g @kanagawa-plugins "battery cpu-usage ram-usage weather time"

      set -g @kanagawa-cpu-usage-label "󰍛 "
      set -g @kanagawa-ram-usage-label " "

      set -g @kanagawa-show-timezone false
      set -g @kanagawa-day-month true

      set -g @kanagawa-show-fahrenheit false
      set -g @kanagawa-show-location false
      set -g @kanagawa-fixed-location "São Paulo"

      run-shell ${pkgs.tmuxPlugins.kanagawa}/share/tmux-plugins/kanagawa/kanagawa.tmux

      set -g @kanagawa-show-right-sep ""
      set -g @kanagawa-show-right-sep ""
    '';
  in {
    home.packages = with pkgs; [
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

    home.file.".config/tmux/plugins.conf".text = ''
      ${kanagawaConfig}

      run-shell ${pkgs.tmuxPlugins.pain-control}/share/tmux-plugins/pain-control/pain-control.tmux
      run-shell ${pkgs.tmuxPlugins.sensible}/share/tmux-plugins/sensible/sensible.tmux
      run-shell ${pkgs.tmuxPlugins.sessionist}/share/tmux-plugins/sessionist/sessionist.tmux
      run-shell ${pkgs.tmuxPlugins.vim-tmux-navigator}/share/tmux-plugins/vim-tmux-navigator/vim-tmux-navigator.tmux

      run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
      run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux
    '';

    home.file.".config/tmux/tmux.conf".source = "${assets.path}/tmux.conf";
  };
}

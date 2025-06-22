{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.tmux;
in {
  options.tmux = {
    enable = lib.mkEnableOption "TMUX";
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      tmuxinator.enable = true;
      keyMode = "vi";
      mouse = true;
      prefix = "C-t";

      extraConfig = ''
        set -g allow-passthrough on
        set -as terminal-features sixel

        # Vim style pane selection
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Status bar
        set-option -g status-position top

        # Use Alt-arrow keys without prefix key to switch panes
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # Shift arrow to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        # Start windows and panes at 1, not 0
        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on

        # Shift Alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        # Keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        # Open panes in current directory
        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
      '';

      plugins = with pkgs; [
        tmuxPlugins.sensible
        tmuxPlugins.yank
        tmuxPlugins.resurrect
        tmuxPlugins.continuum
        tmuxPlugins.vim-tmux-navigator
        {
          plugin = tmuxPlugins.kanagawa;
          extraConfig = ''
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
          '';
        }
      ];
    };
  };
}

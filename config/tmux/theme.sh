#!/usr/bin/env bash

get_theme_option() {
  local value
  value=$(tmux show-option -gqv "@thm_$1")

  echo "$value"
}

bg=$(get_theme_option "surface_low")
fg=$(get_theme_option "fg")
outline=$(get_theme_option "outline")
primary=$(get_theme_option "primary")

default_color="bg=$bg,fg=$fg"

window_status_format=" #I: #W "

# Status
tmux set-option -g status-style "$default_color"
tmux set-option -g status-position "top"
tmux set-option -g status-justify "center"

tmux set-option -g status-left "\
#{?client_prefix,, tmux }\
#[bg=$primary,fg=$bg,bold]#{?client_prefix, tmux ,}"

tmux set-option -g status-right "\
session #S "

tmux set-option -g window-status-format "$window_status_format"
tmux set-option -g window-status-current-format "#[bg=$primary,fg=$bg]$window_status_format#{?window_zoomed_flag,󰊓 ,}"

# Pane
tmux set-option -g pane-border-style "fg=$outline"
tmux set-option -g pane-active-border-style "fg=$fg"

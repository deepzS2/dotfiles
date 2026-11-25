{
  writeShellApplication,
  tmux,
  smug,
  zoxide,
  fzf,
  coreutils,
  gawk,
}:
writeShellApplication {
  name = "tmux-sessionizer";

  runtimeInputs = [
    tmux
    smug
    zoxide
    fzf
    coreutils
    gawk
  ];

  text = ''
    set -euo pipefail

    connect() {
      if [[ -n ''${TMUX:-} ]]; then
        exec tmux switch-client -t "$1"
      else
        exec tmux attach-session -t "$1"
      fi
    }

    if (($# == 0)); then
      selected=$(
        {
          tmux list-sessions -F '[TMUX] #{session_name}' 2>/dev/null || true
          printf '%s\n' "$PWD"
          zoxide query -l || true
        } | awk '!seen[$0]++' | fzf --no-sort --prompt='project> '
      ) || exit 0

      [[ -n $selected ]] || exit 0

      if [[ $selected == '[TMUX] '* ]]; then
        connect "=''${selected#'[TMUX] '}"
      fi
    else
      selected=$1
    fi

    dir=$(cd -- "$selected" && pwd -P)

    while IFS=$'\t' read -r id root; do
      [[ $root == "$dir" ]] && connect "$id"
    done < <(
      tmux list-sessions -F $'#{session_id}\t#{session_path}' \
        2>/dev/null || true
    )

    if [[ -f "$dir/.smug.yml" ]]; then
      cd -- "$dir"
      exec smug start -f .smug.yml -a
    fi

    name=''${dir##*/}
    name=''${name//[.:]/_}
    name=''${name:-root}

    if tmux has-session -t "=$name" 2>/dev/null; then
      hash=$(printf '%s' "$dir" | sha256sum)
      name+="-''${hash:0:8}"

      if tmux has-session -t "=$name" 2>/dev/null; then
        printf 'Session name already in use: %s\n' "$name" >&2
        exit 1
      fi
    fi

    id=$(tmux new-session -dP -F '#{session_id}' \
      -s "$name" -n editor -c "$dir" "nvim; exec \"$SHELL\"")

    tmux new-window -d -t "$id:" -n agent \
      -c "$dir" "pip; exec \"$SHELL\""

    tmux new-window -d -t "$id:" -n server -c "$dir"

    tmux select-window -t "$id:editor"

    connect "$id"
  '';
}

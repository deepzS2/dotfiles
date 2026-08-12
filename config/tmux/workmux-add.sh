#!/usr/bin/env bash
set -euo pipefail

die_wait() {
  echo
  echo "$1 Press any key to close."
  read -r -n 1 -s
  exit 1
}

cmd=
arg=

case "${1:-}" in
branch | b)
  printf 'Branch: '
  read -r branch
  [ -z "$branch" ] && exit 0
  cmd="add"
  arg="$branch"
  ;;

from-branch | f)
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    die_wait "Not a git repository."
  fi
  selection=$(git branch --format='%(refname:short)' | fzf) || true
  [ -z "${selection:-}" ] && exit 0
  cmd="add"
  arg="$selection"
  ;;

prompt | p)
  printf 'Prompt: '
  read -r prompt
  [ -z "$prompt" ] && exit 0
  cmd="add -A -p"
  arg="$prompt"
  ;;

*)
  echo "Usage: ${0##*/} {branch|b|from-branch|f|prompt|p}"
  exit 1
  ;;
esac

workmux "$cmd" "$arg" || die_wait "workmux add failed."

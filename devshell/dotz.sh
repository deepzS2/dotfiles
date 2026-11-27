cd "$(git rev-parse --show-toplevel)" || exit

cmd="${1:-help}"
shift || true

case "$cmd" in
switch | boot | build | test | repl)
  if [[ $# -gt 0 && "$1" != -* ]]; then
    set -- -H "$1" "${@:2}"
  fi

  case "$cmd" in
  switch)
    git add .
    nh os switch . -d always "$@"
    ;;
  boot)
    git add .
    nh os boot . "$@"
    ;;
  *)
    nh os "$cmd" . "$@"
    ;;
  esac
  ;;

lint) statix check . && deadnix . ;;
fmt) nix fmt . "$@" ;;
update) nix flake update "$@" ;;
check) nix flake check "$@" ;;
inspector) nix-inspect --expr "builtins.getFlake \"$PWD\"" ;;
fetch) nix hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url "$1")" ;;

help | -h | --help)
  echo "Usage: dotz <switch|boot|build|test|repl|lint|fmt|update|check|inspector|fetch>"
  ;;

*)
  echo "Unknown command: $cmd" >&2
  exit 1
  ;;
esac

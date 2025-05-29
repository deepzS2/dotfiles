{pkgs, ...}:
pkgs.writeShellApplication {
  name = "get_uptime";
  runtimeInputs = [
    pkgs.procps
  ];
  text = ''
    # uptime cache file
    uptime_file="$HOME/.cache/.uptime"
    [[ ! -f "$uptime_file" ]] && touch "$uptime_file"

    uptime=$(uptime -p | cut -d' ' -f2-)
    time=$(date "+%d/%m/%Y, %I:%M %p")

    notify-send "Pc Usage" "Date: $time\nUsage: $uptime"
    echo "$time -> $uptime" >>"$uptime_file"

    exit 0
  '';
}

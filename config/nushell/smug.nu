# Smug (tmux session manager) completion
def "nu-complete smug projects" [] {
  let config_dir = ($env.SMUG_DIR? | default ($env.HOME | path join ".config/smug")) | path expand

  if not ($config_dir | path exists) {
    return []
  }

  ls $config_dir
  | where type == file and name =~ '\.(yml|yaml)$'
  | get name
  | each { |p| $p | path parse | get stem }
}

export extern "smug list" []

export extern "smug edit" [
  project: string@"nu-complete smug projects"
  --file (-f): string # Path to a custom config file
]

export extern "smug new" [
  project: string # Name of the new project
  --file (-f): string # Path to a custom config file
]

export extern "smug start" [
  project: string@"nu-complete smug projects"
  --file (-f): string    # Path to a custom config file
  --worktree: string     # Use the git worktree (by branch or directory name) as the session root
  --windows (-w): list   # List of windows to start
  --attach (-a)          # Force switch client for a session
  --inside-current-session (-i) # Create all windows inside current session
  --debug (-d)           # Print all commands to ~/.config/smug/smug.log
  --detach               # Detach tmux session
  ...variables: string   # <key>=<value> session variables
]

export extern "smug stop" [
  project: string@"nu-complete smug projects"
  --file (-f): string # Path to a custom config file
]

export extern "smug print" [
  project: string@"nu-complete smug projects"
  --file (-f): string # Path to a custom config file
]

export extern "smug rm" [
  project: string@"nu-complete smug projects" # Remove project configuration
  --file (-f): string # Path to a custom config file
]

export extern "smug switch" [
  project: string@"nu-complete smug projects" # Switch to a project session
  --file (-f): string # Path to a custom config file
  --worktree: string  # Use the git worktree (by branch or directory name) as the session root
  --windows (-w): list # List of windows to start
]

def mux [
  --config-dir: path = "~/.config/smug" # Path to smug configuration dir
] {
  let config_path = ($config_dir | path expand)

  if not ($config_path | path exists) {
    error make { msg: $"Smug config directory not found at: ($config_path)" }
  }

  let configs = (
    ls $config_path 
    | where type == file and name =~ '\.(yml|yaml)$' 
    | get name 
    | each { |p| $p | path parse | get stem }
  )

  if ($configs | is-empty) {
    print $"No configuration files found in ($config_path)"
    return
  }

  let input_list = ($configs | str join "\n")
  let selected = $input_list | ^fzf --prompt="Start session > " --height=40% --layout=reverse --border
  if ($selected | is-empty) {
    return
  }

  let project = ($selected | str trim)
  let inside_tmux = ("TMUX" in $env)

  if $inside_tmux {
    smug start $project -d
    tmux switch-client -t $project
  }  else {
    smug start $project
  }
}

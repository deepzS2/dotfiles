def --env lg [...args] {
  $env.LAZYGIT_NEW_DIR_FILE = "~/.lazygit/newdir" | path expand

  lazygit ...$args

  if ($env.LAZYGIT_NEW_DIR_FILE | path exists) {
    cd (open $env.LAZYGIT_NEW_DIR_FILE)
    rm -f $env.LAZYGIT_NEW_DIR_FILE
  }
}

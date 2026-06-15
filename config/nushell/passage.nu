def "nu-complete passage entries" [] {
  let store_dir = ($env.PASSAGE_DIR? | default ($env.HOME | path join ".passage/store")) | path expand

  if not ($store_dir | path exists) { 
    return [] 
  }

  let pattern = ($store_dir | path join "**/*")

  print $pattern

  glob $pattern
  | where not ($it | str contains ".git") and not ($it == $store_dir)
  | each { |it|
    let rel_path = ($it | str replace $"($store_dir)/" "")

    if ($it | path type) == "dir" {
      $"($rel_path)/"
    } else if ($rel_path | str ends-with ".age") {
      $rel_path | str substring 0..<-4
    } else {
      null
    }
  } 
  | compact
}

export extern "passage" [
  item?: string@"nu-complete passage entries"
]

export extern "passage ls" [
  subfolder?: string@"nu-complete passage entries"
]

export extern "passage show" [
  item?: string@"nu-complete passage entries"
  --clip (-c) # Put the password on the clipboard
]

export extern "passage insert" [
  item?: string@"nu-complete passage entries"
  --echo (-e)      # Echo the password to the console
  --multiline (-m) # Enable multiline input
  --force (-f)     # Overwrite without prompting
]

export extern "passage generate" [
  item?: string@"nu-complete passage entries"
  --no-symbols (-n) # Generate without symbols
  --clip (-c)       # Put the password on the clipboard
  --in-place (-i)   # Replace only the first line of an existing file
  --force (-f)      # Overwrite without prompting
  length?: int      # Length of the generated password
]

export extern "passage edit" [
  item?: string@"nu-complete passage entries"
]

export extern "passage rm" [
  item?: string@"nu-complete passage entries"
  --recursive (-r) # Delete directory and its contents
  --force (-f)     # Delete without prompting
]

export extern "passage mv" [
  old_path: string@"nu-complete passage entries"
  new_path: string@"nu-complete passage entries"
  --force (-f)
]

export extern "passage cp" [
  old_path: string@"nu-complete passage entries"
  new_path: string@"nu-complete passage entries"
  --force (-f)
]

export extern "passage git" [
  ...args: string
]

export extern "passage help" []
export extern "passage version" []

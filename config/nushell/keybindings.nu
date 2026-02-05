$env.config.keybindings ++= [
  {
    name: complete_hint
    modifier: control
    keycode: char_f
    mode: [emacs, vi_normal, vi_insert]
    event: {
      until: [
        { send: HistoryHintComplete }
        { edit: MoveToLineEnd select: false }
      ]
    }
  }
  {
    name: open_editor
    modifier: control
    keycode: char_e
    mode: [emacs, vi_normal, vi_insert]
    event: {
      send: OpenEditor
    }
  }
  {
    name: clear
    modifier: alt
    keycode: char_w
    mode: [emacs, vi_normal, vi_insert]
    event: {
      send: ClearScreen
    }
  }
  {
    name: undo
    modifier: control
    keycode: char_u
    mode: [emacs, vi_normal, vi_insert]
    event: {
      edit: Undo
    }
  }
  {
    name: redo
    modifier: control
    keycode: char_r
    mode: [emacs, vi_normal, vi_insert]
    event: {
      edit: Redo
    }
  }
  {
    name: fuzzy_zoxide
    modifier: control
    keycode: char_o
    mode: [emacs, vi_normal, vi_insert]
    event: {
      send: executehostcommand
      cmd: "cdi"
    }
  }
{
  name: fuzzy_history
  modifier: control
  keycode: char_x
  mode: [emacs, vi_normal, vi_insert]
  event: {
    send: executehostcommand
    cmd: "commandline edit (
        history
        | each { |it| $it.command }
        | uniq
        | reverse
        | str join \"\n\"
        | fzf --height 60% --layout reverse --border --multi
    )"
  }
}
]

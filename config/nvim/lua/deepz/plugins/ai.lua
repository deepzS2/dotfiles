return {
  'folke/sidekick.nvim',
  opts = {
    cli = {
      ---@class sidekick.cli.Mux
      mux = {
        enabled = true,
        backend = 'tmux',
        create = 'split',
        split = {
          vertical = true, -- vertical or horizontal split
          size = 0.5, -- size of the split (0-1 for percentage)
        },
      },
    },
    tools = {
      opencode = { env = { OPENCODE_THEME = 'kanagawa' } },
    },
  },
  keys = {
    {
      '<tab>',
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require('sidekick').nes_jump_or_apply() then
          return '<Tab>' -- fallback to normal tab
        end
      end,
      expr = true,
      desc = 'Goto/Apply Next Edit Suggestion',
    },
    {
      '<c-.>',
      function()
        require('sidekick.cli').toggle { name = 'opencode' }
      end,
      desc = 'Sidekick Toggle',
      mode = { 'n', 't', 'i', 'x' },
    },
    {
      '<leader>at',
      function()
        require('sidekick.cli').send { msg = '{this}', name = 'opencode' }
      end,
      mode = { 'x', 'n' },
      desc = '[A]I Send [T]his',
    },
    {
      '<leader>af',
      function()
        require('sidekick.cli').send { msg = '{file}', name = 'opencode' }
      end,
      desc = '[A]I Send [F]ile',
    },
    {
      '<leader>av',
      function()
        require('sidekick.cli').send { msg = '{selection}', name = 'opencode' }
      end,
      mode = { 'x' },
      desc = '[A]I Send [S]election',
    },
    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      mode = { 'n', 'x' },
      desc = '[A]I [P]rompts',
    },
    -- Example of a keybinding to open Claude directly
    {
      '<leader>ac',
      function()
        require('sidekick.cli').toggle { name = 'opencode', focus = true }
      end,
      desc = '[A]I [C]hat',
    },
  },
}

-- My coding agent of choice
local TOOL = 'pi'

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
      desc = 'Goto/Apply next edit suggestion',
    },
    {
      '<c-.>',
      function()
        require('sidekick.cli').toggle { name = TOOL }
      end,
      desc = 'Sidekick toggle',
      mode = { 'n', 't', 'i', 'x' },
    },
    {
      '<leader>at',
      function()
        require('sidekick.cli').send { msg = '{this}', name = TOOL }
      end,
      mode = { 'x', 'n' },
      desc = 'AI send this',
    },
    {
      '<leader>af',
      function()
        require('sidekick.cli').send { msg = '{file}', name = TOOL }
      end,
      desc = 'AI send file',
    },
    {
      '<leader>av',
      function()
        require('sidekick.cli').send { msg = '{selection}', name = TOOL }
      end,
      mode = { 'x' },
      desc = 'AI send selection',
    },
    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      mode = { 'n', 'x' },
      desc = 'AI prompts',
    },
    -- Example of a keybinding to open Claude directly
    {
      '<leader>ac',
      function()
        require('sidekick.cli').toggle { name = TOOL, focus = true }
      end,
      desc = 'AI chat',
    },
  },
}

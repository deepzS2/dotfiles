return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    {
      '<leader>aa',
      '<Cmd>CodeCompanionActions<CR>',
      desc = '[A]I [A]ctions',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ac',
      '<Cmd>CodeCompanionChat Toggle<CR>',
      desc = '[A]I [C]hat',
    },
    {
      '<leader>ai',
      '<Cmd>CodeCompanion<CR>',
      desc = '[A]I [I]nline',
      mode = { 'n', 'x' },
    },
  },
  opts = {
    display = {
      action_palette = {
        width = 95,
        height = 10,
        provider = 'default', -- Can be "default", "telescope", or "mini_pick". If not specified, the plugin will autodetect installed providers.
      },
      diff = {
        enabled = true,
        close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
        layout = 'vertical', -- vertical|horizontal split for default provider
        opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
        provider = 'mini_diff', -- default|mini_diff
      },
    },
    adapters = {
      copilot = function()
        return require('codecompanion.adapters').extend('copilot', {
          schema = {
            model = {
              default = 'claude-3.7-sonnet',
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = 'copilot',
      },
      inline = {
        adapter = 'copilot',
      },
    },
  },
}

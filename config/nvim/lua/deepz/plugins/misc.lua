return {
  -- Comments
  {
    'numToStr/Comment.nvim',
    name = 'comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
    },
    keys = {
      {
        '<leader>st',
        function()
          Snacks.picker.todo_comments()
        end,
        desc = '[S]earch [T]odo',
      },
      {
        '<leader>sT',
        function()
          Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
        end,
        desc = '[S]earch [T]odo/Fix/Fixme',
      },
    },
  },

  -- TMUX + NVIM <3
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    keys = {
      { mode = 'n', '<c-h>', '<cmd>TmuxNavigateLeft<cr>' },
      { mode = 'n', '<c-j>', '<cmd>TmuxNavigateDown<cr>' },
      { mode = 'n', '<c-k>', '<cmd>TmuxNavigateUp<cr>' },
      { mode = 'n', '<c-l>', '<cmd>TmuxNavigateRight<cr>' },
      { mode = 'n', '<c-\\>', '<cmd>TmuxNavigatePrevious<cr>' },
      { mode = 't', '<c-h>', '<C-w><cmd>TmuxNavigateLeft<cr>' },
      { mode = 't', '<c-j>', '<C-w><cmd>TmuxNavigateDown<cr>' },
      { mode = 't', '<c-k>', '<C-w><cmd>TmuxNavigateUp<cr>' },
      { mode = 't', '<c-l>', '<C-w><cmd>TmuxNavigateRight<cr>' },
      { mode = 't', '<c-\\>', '<C-w><cmd>TmuxNavigatePrevious<cr>' },
    },
    init = function()
      -- Disable default mappings to make it work in terminal mode
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },

  -- Undotree
  {
    'jiaoshijie/undotree',
    dependencies = 'nvim-lua/plenary.nvim',
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      {
        '<leader>u',
        "<cmd>lua require('undotree').toggle()<cr>",
        desc = 'Undotree',
      },
    },
  },

  -- Cloak
  {
    'laytan/cloak.nvim',
    opts = {},
  },

  -- Hardtime (getting rid of bad habits)
  {
    'm4xshen/hardtime.nvim',
    lazy = false,
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
  },

  -- Indentation detection
  {
    'NMAC427/guess-indent.nvim',
    opts = {},
  },
}

return {
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
    opts = {
      restricted_keys = {
        ['h'] = false,
        ['j'] = false,
        ['k'] = false,
        ['l'] = false,
      },
    },
  },

  -- Indentation detection
  {
    'NMAC427/guess-indent.nvim',
    opts = {},
  },

  -- Markdown preview
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },

  -- File tags like Harpoon
  {
    'cbochs/grapple.nvim',
    opts = {
      scope = 'git',
      icons = false,
      status = false,
    },
    keys = {
      { '<leader>A', '<cmd>Grapple toggle<cr>', desc = '[A]dd file to tags' },
      { '<C-e>', '<cmd>Grapple toggle_tags<cr>', desc = 'Toggle tags menu' },

      { '<C-m>', '<cmd>Grapple select index=1<cr>', desc = 'Select first tag' },
      { '<C-t>', '<cmd>Grapple select index=2<cr>', desc = 'Select second tag' },
      { '<C-n>', '<cmd>Grapple select index=3<cr>', desc = 'Select third tag' },
      { '<C-s>', '<cmd>Grapple select index=4<cr>', desc = 'Select fourth tag' },

      { '<C-S-n>', '<cmd>Grapple cycle_tags next<cr>', desc = 'Go to next tag' },
      { '<C-S-p>', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Go to previous tag' },
    },
  },
}

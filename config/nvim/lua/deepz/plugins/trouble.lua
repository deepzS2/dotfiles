return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/todo-comments.nvim' },
  opts = {
    focus = true,
  },
  keys = {
    { '<leader>xw', '<cmd>Trouble diagnostics toggle<CR>', desc = '[X] Trouble [W]orkspace Diagnostics' },
    { '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = '[X] Trouble [D]ocument Diagnostics' },
    { '<leader>xq', '<cmd>Trouble quickfix toggle<CR>', desc = '[X] Trouble [Q]uickfix List' },
    { '<leader>xl', '<cmd>Trouble loclist toggle<CR>', desc = '[X] Trouble [L]ocation List' },
    { '<leader>xt', '<cmd>Trouble todo toggle<CR>', desc = '[X] Trouble [T]ODO List' },
  },
}

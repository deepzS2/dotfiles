return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = {
    modes = {
      lsp = {
        win = { position = 'right' },
      },
    },
  },
  keys = {
    { '<leader>xw', '<cmd>Trouble diagnostics toggle<CR>', desc = '[X] Trouble [W]orkspace Diagnostics' },
    { '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = '[X] Trouble [D]ocument Diagnostics' },
    { '<leader>xq', '<cmd>Trouble qflist toggle<CR>', desc = '[X] Trouble [Q]uickfix List' },
    { '<leader>xl', '<cmd>Trouble loclist toggle<CR>', desc = '[X] Trouble [L]ocation List' },
    { '<leader>cs', '<cmd>Trouble symbols toggle<CR>', desc = '[C]ode [S]ymbols (Trouble)' },
    { '<leader>cL', '<cmd>Trouble lsp toggle<CR>', desc = '[C]ode [L]SP (Trouble)' },
    {
      '[q',
      function()
        if require('trouble').is_open() then
          require('trouble').prev { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cprev)

          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Previous Trouble/Quickfix Item',
    },
    {
      ']q',
      function()
        if require('trouble').is_open() then
          require('trouble').next { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cnext)

          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Next Trouble/Quickfix Item',
    },
    { '<leader>xt', '<cmd>Trouble todo toggle<CR>', desc = '[X] Trouble [T]ODO List' },
  },
}

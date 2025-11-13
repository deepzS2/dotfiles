return {
  'cbochs/grapple.nvim',
  opts = {
    scope = 'git',
    icons = false,
    status = false,
  },
  keys = {
    { '<leader>A', '<cmd>Grapple toggle<cr>', desc = '[A]dd file to tags' },
    { '<C-e>', '<cmd>Grapple toggle_tags<cr>', desc = 'Toggle tags menu' },
  },
}

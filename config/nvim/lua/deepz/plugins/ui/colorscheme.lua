return {
  'rebelot/kanagawa.nvim',
  priority = 1000,
  lazy = true,
  opts = {
    variant = 'wave',
    transparent = true,
  },
  init = function()
    vim.cmd.colorscheme 'kanagawa'

    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'
  end,
}

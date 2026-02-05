return {
  'akinsho/bufferline.nvim',
  dependencies = {
    -- 'nvim-tree/nvim-web-devicons',
    'nvim-mini/mini.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = '[B]uffer Toggle [P]in' },
    { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = '[B]uffer Delete Non-[P]inned' },
    { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = '[B]uffer Delete Others' },
    { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = '[B]uffer Delete Others to the [R]ight' },
    { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = '[B]uffer Delete Others to the [L]eft' },
    { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev [B]uffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next [B]uffer' },
    { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev [B]uffer' },
    { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next [B]uffer' },
    { '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move [B]uffer Prev' },
    { ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move [B]uffer next' },
  },
  opts = {
    options = {
      mode = 'buffers',
      themable = true,
      numbers = 'none',
      diagnostics = 'nvim_lsp',
      always_show_bufferline = false,
      close_command = function(bufid)
        Snacks.bufdelete.delete(bufid)
      end,
      right_mouse_command = function(bufid)
        Snacks.bufdelete.delete(bufid)
      end,
    },
  },
  config = function(_, opts)
    require('bufferline').setup(opts)
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}

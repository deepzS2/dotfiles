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
    { '<S-TAB>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev [B]uffer' },
    { '<TAB>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next [B]uffer' },
    { '[b', '<cmd>BufferLineMovePrev<cr>', desc = 'Move [B]uffer Prev' },
    { ']b', '<cmd>BufferLineMoveNext<cr>', desc = 'Move [B]uffer next' },
  },
  opts = {
    options = {
      mode = 'buffers',
      themable = true,
      numbers = 'none',
      always_show_bufferline = true,
      close_command = function(bufid)
        Snacks.bufdelete.delete(bufid)
      end,
    },
  },
}

return {
  -- Colorscheme
  {
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
  },

  -- Floating statusline
  {
    'b0o/incline.nvim',
    -- Optional: Lazy load Incline
    event = 'VeryLazy',
    opts = {
      window = {
        padding = 0,
        margin = {
          horizontal = {
            right = 0,
            left = 1,
          },
        },
      },
      highlight = {
        groups = {
          InclineNormal = {
            default = true,
            group = 'MiniStatuslineFileinfo',
          },
          InclineNormalNC = {
            default = true,
            group = 'MiniStatuslineFileinfo',
          },
        },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')

        if filename == '' then
          filename = '[No Name]'
        end

        local ft_icon, ft_hl = MiniIcons.get('file', filename)
        local modified = vim.bo[props.buf].modified

        if modified then
          filename = filename .. ' [+]'
        end

        return {
          ft_icon and { ' ', ft_icon, ' ', group = ft_hl } or '',
          ' ',
          { filename, gui = modified and 'bold,italic' or 'bold' },
          ' ',
        }
      end,
    },
  },

  -- Nice UI
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'MunifTanjim/nui.nvim', lazy = true },
    },
    keys = {
      {
        '<S-Enter>',
        function()
          require('noice').redirect(vim.fn.getcmdline())
        end,
        mode = 'c',
        desc = 'Redirect Cmdline',
      },
      {
        '<C-f>',
        function()
          if not require('noice.lsp').scroll(4) then
            return '<c-f>'
          end
        end,
        silent = true,
        expr = true,
        desc = 'Scroll Forward',
        mode = { 'i', 'n', 's' },
      },
      {
        '<C-b>',
        function()
          if not require('noice.lsp').scroll(-4) then
            return '<c-b>'
          end
        end,
        silent = true,
        expr = true,
        desc = 'Scroll Backward',
        mode = { 'i', 'n', 's' },
      },
    },
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
  },

  -- Tabs-like UI
  {
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
  },
}

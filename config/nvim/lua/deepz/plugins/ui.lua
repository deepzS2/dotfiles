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
}

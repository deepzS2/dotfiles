return {
  'nvim-mini/mini.nvim',
  version = '*',
  dependencies = {
    'rafamadriz/friendly-snippets',
    { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true, opts = { enable_autocmd = false } },
  },
  keys = {
    {
      '<leader>gt',
      function()
        MiniDiff.toggle_overlay(0)
      end,
      desc = '[G]it [T]oggle Overlay',
    },
    {
      '<leader>C',
      function()
        MiniFiles.open(vim.uv.cwd(), false)
      end,
      desc = '[C]WD File Explorer',
    },
    {
      '<leader><space>',
      function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
      end,
      desc = '[F]ile Explorer',
    },
  },
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    local gen_treesitter_spec = require('mini.ai').gen_spec.treesitter
    require('mini.ai').setup {
      custom_textobjects = {
        -- snake_case, camelCase, PascalCase, etc. support
        -- More about it in https://github.com/nvim-mini/mini.nvim/discussions/1434
        e = {
          {
            '%u[%l%d]+%f[^%l%d]',
            '%f[%S][%l%d]+%f[^%l%d]',
            '%f[%P][%l%d]+%f[^%l%d]',
            '^[%l%d]+%f[^%l%d]',
          },
          '^().*()$',
        },
        i = gen_treesitter_spec {
          a = '@conditional.outer',
          i = '@conditional.inner',
        },
        l = gen_treesitter_spec {
          a = '@loop.outer',
          i = '@loop.inner',
        },
        c = gen_treesitter_spec {
          a = '@class.outer',
          i = '@class.inner',
        },
        ['='] = gen_treesitter_spec {
          a = '@assignment.outer',
          i = '@assignment.inner',
          h = '@assignment.lhs',
          l = '@assignment.rhs',
        },
        [':'] = gen_treesitter_spec {
          a = '@property.outer',
          i = '@property.inner',
          h = '@property.lhs',
          l = '@property.rhs',
        },
      },
      n_lines = 500,
    }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Autopairs ([{}])
    require('mini.pairs').setup()

    -- Operators
    require('mini.operators').setup()

    -- File explorer
    require('mini.files').setup {
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 30,
      },
    }

    -- Icons
    require('mini.icons').setup {
      file = {
        ['.go-version'] = { glyph = '', hl = 'MiniIconsBlue' },
      },
      filetype = {
        gotmpl = { glyph = '󰟓', hl = 'MiniIconsGrey' },
      },
    }

    MiniIcons.mock_nvim_web_devicons()

    -- Diff
    require('mini.diff').setup {
      view = {
        style = 'sign',
        signs = {
          add = '',
          change = '',
          delete = '',
        },
      },
    }

    -- Snippets
    require('mini.snippets').setup {
      snippets = {
        require('mini.snippets').gen_loader.from_lang(),
      },
    }

    -- Move selection in lines or columns
    require('mini.move').setup {
      mappings = {
        up = 'K',
        down = 'J',
      },
    }

    require('mini.comment').setup {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
        end,
      },
    }

    -- On rename file event
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesActionRename',
      callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
      end,
    })

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    statusline.setup {
      content = {
        active = function()
          -- Sidekick Highlight Group
          vim.api.nvim_set_hl(0, 'SidekickError', { fg = Snacks.util.color 'DiagnosticError', bg = Snacks.util.color('MiniStatuslineFileinfo', 'bg') })
          vim.api.nvim_set_hl(0, 'SidekickMsgArea', { fg = Snacks.util.color 'MsgArea', bg = Snacks.util.color('MiniStatuslineFileinfo', 'bg') })
          vim.api.nvim_set_hl(0, 'SidekickWarn', { fg = Snacks.util.color 'DiagnosticWarn', bg = Snacks.util.color('MiniStatuslineFileinfo', 'bg') })
          vim.api.nvim_set_hl(0, 'SidekickSpecial', { fg = Snacks.util.color 'Special', bg = Snacks.util.color('MiniStatuslineFileinfo', 'bg') })
          vim.api.nvim_set_hl(0, 'SidekickCli', { link = 'TodoBgPERF' })

          -- Sidekick.nvim statusline configuration
          local icons = {
            Error = { '', 'SidekickError' },
            Inactive = { '', 'SidekickMsgArea' },
            Warning = { '', 'SidekickWarn' },
            Normal = { '', 'SidekickSpecial' },
          }

          -- You can configure sections in the statusline by overriding their
          -- default behavior. For example, here we set the section for
          -- cursor location to LINE:COLUMN
          ---@diagnostic disable-next-line: duplicate-set-field
          statusline.section_location = function()
            return '%2l:%-2v'
          end

          -- Custom section for Sidekick status
          ---@diagnostic disable-next-line: duplicate-set-field
          statusline.section_sidekick = function()
            local status = require('sidekick.status').get()
            local sidekick_hl = status and (status.busy and 'SidekickWarn' or vim.tbl_get(icons, status.kind, 2))

            return status and vim.tbl_get(icons, status.kind, 1) or '', sidekick_hl
          end

          -- Custom section for Sidekick CLI status
          ---@diagnostic disable-next-line: duplicate-set-field
          statusline.section_sidekick_cli = function()
            local cli_status = require('sidekick.status').cli()
            if #cli_status == 0 then
              return ''
            end

            local count = #cli_status > 2 and ' ' .. #cli_status or ''
            return '' .. ' opencode' .. count
          end

          local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
          local git = MiniStatusline.section_git { trunc_width = 40 }
          local diffline = MiniStatusline.section_diff { trunc_width = 75 }
          local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
          local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
          local filename = MiniStatusline.section_filename { trunc_width = 140 }
          local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
          local location = MiniStatusline.section_location { trunc_width = 75 }
          local search = MiniStatusline.section_searchcount { trunc_width = 75 }
          local sidekick, sidekick_hl = statusline.section_sidekick()
          local sidekick_cli = statusline.section_sidekick_cli()

          return MiniStatusline.combine_groups {
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diffline, diagnostics, lsp } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = sidekick_hl, strings = { sidekick } },
            { hl = 'SidekickCli', strings = { sidekick_cli } },
            { hl = mode_hl, strings = { search, location } },
          }
        end,
      },
      -- set use_icons to true if you have a Nerd Font
      use_icons = vim.g.have_nerd_font,
    }

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}

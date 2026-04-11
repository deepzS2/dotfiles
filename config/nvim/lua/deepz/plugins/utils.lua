return {
  {
    'nvim-mini/mini.nvim',
    version = '*',
    lazy = false,
    dependencies = {
      'rafamadriz/friendly-snippets',
      { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true, opts = { enable_autocmd = false } },
    },
    keys = {
      {
        '<leader>to',
        function()
          MiniDiff.toggle_overlay(0)
        end,
        desc = 'Toggle diff overlay',
      },
      {
        '<leader>C',
        function()
          MiniFiles.open(vim.uv.cwd(), false)
        end,
        desc = 'File explorer (CWD)',
      },
      {
        '<leader><space>',
        function()
          MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        end,
        desc = 'File explorer',
      },
    },
    config = function()
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

      -- Automatic session
      require('mini.sessions').setup {
        verbose = { write = false },
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

      -- File explorer
      require('mini.files').setup {
        content = {
          filter = function(fs_entry)
            return fs_entry.name ~= '.git'
          end,
        },
        mappings = {
          go_in = 'L',
          go_in_plus = '',
          go_out = 'H',
          go_out_plus = '',
        },
        windows = {
          preview = true,
          width_focus = 40,
          width_preview = 80,
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

      -- Next key clues
      local miniclue = require 'mini.clue'
      miniclue.setup {
        triggers = {
          -- Leader triggers
          { mode = { 'n', 'x' }, keys = '<Leader>' },

          -- `[` and `]` keys
          { mode = 'n', keys = '[' },
          { mode = 'n', keys = ']' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = { 'n', 'x' }, keys = 'g' },

          -- Marks
          { mode = { 'n', 'x' }, keys = "'" },
          { mode = { 'n', 'x' }, keys = '`' },

          -- Registers
          { mode = { 'n', 'x' }, keys = '"' },
          { mode = { 'i', 'c' }, keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = { 'n', 'x' }, keys = 'z' },
        },

        clues = {
          { mode = 'n', keys = '<leader>a', desc = '+AI' },
          { mode = { 'n', 'x' }, keys = '<leader>c', desc = '+Code' },
          { mode = 'n', keys = '<leader>d', desc = '+Debug' },
          { mode = 'n', keys = '<leader>l', desc = '+LSP' },
          { mode = 'n', keys = '<leader>s', desc = '+Search' },
          { mode = 'n', keys = '<leader>w', desc = '+Windows' },
          { mode = 'n', keys = '<leader>t', desc = '+Toggle' },
          { mode = { 'n', 'v' }, keys = '<leader>g', desc = '+Git' },
          { mode = { 'n', 'v' }, keys = '<leader>gh', desc = '+Hunk' },
          { mode = 'n', keys = '<leader>x', desc = '+Trouble' },

          miniclue.gen_clues.square_brackets(),
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },

        window = {
          delay = 100,
        },
      }

      -- On rename file event
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })

      -- Auto-create session on first visit to a directory
      vim.api.nvim_create_autocmd('VimEnter', {
        group = vim.api.nvim_create_augroup('mini-sessions-auto-create', { clear = true }),
        callback = function()
          local sessions = require 'mini.sessions'
          local cwd = vim.uv.cwd()
          if not cwd then
            return
          end

          local session_name = vim.fs.basename(cwd)

          if not sessions.detected[session_name] then
            sessions.write(session_name, { force = true })
          end
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
  },

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    --- @type snacks.Config
    opts = {
      animate = { enabled = true },
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
▓█████▄ ▓█████ ▓█████  ██▓███  ▒███████▒
▒██▀ ██▌▓█   ▀ ▓█   ▀ ▓██░  ██▒▒ ▒ ▒ ▄▀░
░██   █▌▒███   ▒███   ▓██░ ██▓▒░ ▒ ▄▀▒░ 
░▓█▄   ▌▒▓█  ▄ ▒▓█  ▄ ▒██▄█▓▒ ▒  ▄▀▒   ░
░▒████▓ ░▒████▒░▒████▒▒██▒ ░  ░▒███████▒
 ▒▒▓  ▒ ░░ ▒░ ░░░ ▒░ ░▒▓▒░ ░  ░░▒▒ ▓░▒░▒
 ░ ▒  ▒  ░ ░  ░ ░ ░  ░░▒ ░     ░░▒ ▒ ░ ▒
 ░ ░  ░    ░      ░   ░░       ░ ░ ░ ░ ░
   ░       ░  ░   ░  ░           ░ ░    
 ░                             ░        
]],
        },
        sections = {
          { section = 'header' },
          { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
          { section = 'keys', indent = 2, padding = 1 },
          { section = 'startup' },
        },
      },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      -- Zen
      {
        '<leader>z',
        function()
          Snacks.zen()
        end,
        desc = 'Toggle zen mode',
      },
      {
        '<leader>Z',
        function()
          Snacks.zen.zoom()
        end,
        desc = 'Toggle zoom',
      },

      -- Scratch
      {
        '<leader>.',
        function()
          Snacks.scratch()
        end,
        desc = 'Scratch buffer',
      },
      {
        '<leader>sS',
        function()
          Snacks.scratch.select()
        end,
        desc = 'Select scratch buffer',
      },

      -- Buffer delete
      {
        '<leader>X',
        function()
          Snacks.bufdelete()
        end,
        desc = 'Buffer delete',
      },

      -- Git and LazyGit
      {
        '<leader>gB',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'Git browse',
      },
      {
        '<leader>go',
        function()
          Snacks.lazygit()
        end,
        desc = 'Open lazygit',
      },
      {
        '<leader>gf',
        function()
          Snacks.lazygit.log_file()
        end,
        desc = 'Lazygit file log',
      },
      {
        '<leader>gl',
        function()
          Snacks.lazygit.log()
        end,
        desc = 'Lazygit log',
      },

      -- Words
      {
        ']]',
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = 'Next word reference',
        mode = { 'n', 't' },
      },
      {
        '[[',
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = 'Prev word reference',
        mode = { 'n', 't' },
      },

      -- Picker
      {
        '<leader>sf',
        function()
          Snacks.picker.files()
        end,
        desc = 'Search files',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = 'Search keymaps',
      },
      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        desc = 'Search help',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = 'Search registers',
      },
      {
        '<leader>sd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = 'Search diagnostics',
      },
      {
        '<leader>sr',
        function()
          Snacks.picker.recent()
        end,
        desc = 'Search recent files',
      },
      {
        '<leader>sR',
        function()
          Snacks.picker.resume()
        end,
        desc = 'Search resume',
      },
      {
        '<leader>sb',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Search buffer lines',
      },
      {
        '<leader>sB',
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = 'Search open buffers',
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = 'Search visual selection or word',
        mode = { 'n', 'x' },
      },
      {
        '<leader>sq',
        function()
          Snacks.picker.qflist()
        end,
        desc = 'Search quickfix list',
      },
      {
        '<leader>u',
        function()
          Snacks.picker.undo()
        end,
        desc = 'Undotree',
      },
      {
        '<leader>,',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Search buffers',
      },
      {
        '<leader>:',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>ts'
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tw'
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>tL'
          Snacks.toggle.diagnostics():map '<leader>td'
          Snacks.toggle.line_number():map '<leader>tl'
          Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>tc'
          Snacks.toggle.treesitter():map '<leader>tT'
          Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>tb'
          Snacks.toggle.inlay_hints():map '<leader>th'
          Snacks.toggle.indent():map '<leader>tg'
          Snacks.toggle.dim():map '<leader>tD'
        end,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('snacks-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf
          local picker = Snacks.picker

          -- Find references for the word under your cursor.
          vim.keymap.set('n', 'grr', picker.lsp_references, { buffer = buf, desc = 'Goto references' })

          -- Jump to the implementation of the word under your cursor.
          -- Useful when your language has ways of declaring types without an actual implementation.
          vim.keymap.set('n', 'gri', picker.lsp_implementations, { buffer = buf, desc = 'Goto implementation' })

          -- Jump to the definition of the word under your cursor.
          -- This is where a variable was first declared, or where a function is defined, etc.
          -- To jump back, press <C-t>.
          vim.keymap.set('n', 'grd', picker.lsp_definitions, { buffer = buf, desc = 'Goto definition' })
          vim.keymap.set('n', 'grD', picker.lsp_declarations, { buffer = buf, desc = 'Goto declaration' })

          -- Fuzzy find all the symbols in your current document.
          -- Symbols are things like variables, functions, types, etc.
          vim.keymap.set('n', 'gO', picker.lsp_symbols, { buffer = buf, desc = 'Open document symbols' })

          -- Fuzzy find all the symbols in your current workspace.
          -- Similar to document symbols, except searches over your entire project.
          vim.keymap.set('n', 'gW', function()
            picker.lsp_symbols { workspace = true }
          end, { buffer = buf, desc = 'Open workspace symbols' })

          -- Jump to the type of the word under your cursor.
          -- Useful when you're not sure what type a variable is and you want to see
          -- the definition of its *type*, not where it was *defined*.
          vim.keymap.set('n', 'grt', picker.lsp_type_definitions, { buffer = buf, desc = 'Goto type definition' })
        end,
      })
    end,
  },
}

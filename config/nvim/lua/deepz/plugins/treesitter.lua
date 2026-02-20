local mnw_utils = require 'deepz.utils.mnw'

return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    dependencies = {
      'windwp/nvim-ts-autotag',
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main', lazy = false },
    },
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      if not mnw_utils.is_nix then
        require('nvim-treesitter').install {
          'bash',
          'c',
          'diff',
          'html',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'query',
          'vim',
          'vimdoc',
          'rust',
          'ron',
          'go',
          'gomod',
        }
      end

      require('nvim-treesitter-textobjects').setup {
        move = {
          set_jumps = true,
        },
      }

      ---@class KeymapSetOpts
      ---@field query string Treesitter query
      ---@field desc string Keymap description

      ---@class MoveKeymaps
      ---@field goto_next_start table<string, KeymapSetOpts>
      ---@field goto_next_end table<string, KeymapSetOpts>
      ---@field goto_previous_start table<string, KeymapSetOpts>
      ---@field goto_previous_end table<string, KeymapSetOpts>

      ---@class SwapKeymaps
      ---@field swap_previous table<string, KeymapSetOpts>
      ---@field swap_next table<string, KeymapSetOpts>

      ---@class (exact) KeymapsConfig Treesitter textobjects keymaps definitions
      ---@field move MoveKeymaps Move keymaps
      ---@field swap SwapKeymaps Swap keymaps
      local keymaps = {
        move = {
          goto_next_start = {
            [']f'] = { query = '@function.outer', desc = 'Next method/function def start' },
            [']c'] = { query = '@class.outer', desc = 'Next class start' },
            [']i'] = { query = '@conditional.outer', desc = 'Next conditional start' },
            [']l'] = { query = '@loop.outer', desc = 'Next loop start' },
            [']a'] = { query = '@parameter.inner', desc = 'Next parameter start' },
            [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
            [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
          },
          goto_next_end = {
            [']F'] = { query = '@function.outer', desc = 'Next method/function def end' },
            [']C'] = { query = '@class.outer', desc = 'Next class end' },
            [']I'] = { query = '@conditional.outer', desc = 'Next conditional end' },
            [']L'] = { query = '@loop.outer', desc = 'Next loop end' },
            [']A'] = { query = '@parameter.inner', desc = 'Next parameter end' },
          },
          goto_previous_start = {
            ['[f'] = { query = '@function.outer', desc = 'Prev method/function def start' },
            ['[c'] = { query = '@class.outer', desc = 'Prev class start' },
            ['[i'] = { query = '@conditional.outer', desc = 'Prev conditional start' },
            ['[l'] = { query = '@loop.outer', desc = 'Prev loop start' },
            ['[a'] = { query = '@parameter.inner', desc = 'Prev parameter start' },
          },
          goto_previous_end = {
            ['[F'] = { query = '@function.outer', desc = 'Prev method/function def end' },
            ['[C'] = { query = '@class.outer', desc = 'Prev class end' },
            ['[I'] = { query = '@conditional.outer', desc = 'Prev conditional end' },
            ['[L'] = { query = '@loop.outer', desc = 'Prev loop end' },
            ['[A'] = { query = '@parameter.inner', desc = 'Prev parameter end' },
          },
        },
        swap = {
          swap_next = {
            ['<M-s>a'] = { query = '@parameter.inner', desc = 'Swap next parameter' },
            ['<M-s>:'] = { query = '@property.outer', desc = 'Swap next property' },
            ['<M-s>f'] = { query = '@function.outer', desc = 'Swap next function' },
          },
          swap_previous = {
            ['<M-a>a'] = { query = '@parameter.inner', desc = 'Swap previous parameter' },
            ['<M-a>:'] = { query = '@property.outer', desc = 'Swap previous property' },
            ['<M-a>f'] = { query = '@function.outer', desc = 'Swap previous function' },
          },
        },
      }

      ---Create treesitter textobjects keymaps
      ---@param buf integer Buffer number
      local function attach_textobjects_mapping(buf)
        for method, keys in pairs(keymaps.move) do
          for key, definition in pairs(keys) do
            vim.keymap.set({ 'n', 'x', 'o' }, key, function()
              require('nvim-treesitter-textobjects.move')[method](definition.query, 'textobjects')
            end, {
              buffer = buf,
              desc = definition.desc,
              silent = true,
            })
          end
        end

        for method, keys in pairs(keymaps.swap) do
          for key, definition in pairs(keys) do
            vim.keymap.set('n', key, function()
              require('nvim-treesitter-textobjects.swap')[method](definition.query, 'textobjects')
            end, {
              buffer = buf,
              desc = definition.desc,
              silent = true,
            })
          end
        end

        local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'

        -- Repeat movement with ; and ,
        -- ensure ; goes forward and , goes backward regardless of the last direction
        vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
        vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

        -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
        vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
        vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
        vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
        vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = require('nvim-treesitter').get_available(),
        callback = function(ev)
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          attach_textobjects_mapping(ev.buf)
        end,
      })
    end,
  },
}

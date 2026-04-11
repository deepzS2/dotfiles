return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'folke/snacks.nvim',
    },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']h', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Next git hunk' })

        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[h', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Previous git hunk' })

        -- Actions
        -- visual mode
        map('v', '<leader>ghs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git hunk stage' })
        map('v', '<leader>ghr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git hunk reset' })

        -- normal mode
        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Git stage buffer' })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Git reset buffer' })
        map('n', '<leader>gb', function()
          gitsigns.blame_line { full = true }
        end, { desc = 'Git blame line' })
        map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Git diff against index' })
        map('n', '<leader>gD', function()
          gitsigns.diffthis '@'
        end, { desc = 'Git diff against last commit' })
        map('n', '<leader>gQ', function()
          gitsigns.setqflist 'all'
        end, { desc = 'Git quickfix list workspace' })
        map('n', '<leader>gq', gitsigns.setqflist, { desc = 'Git quickfix list file' })
        map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'Git stage hunk' })
        map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'Git reset hunk' })
        map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = 'Git preview hunk' })
        map('n', '<leader>ghp', gitsigns.preview_hunk_inline, { desc = 'Git preview hunk inline' })

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle git blame line' })
        map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = 'Toggle git word diff' })

        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
      end,
    },
  },

  -- Search and replace
  {
    'MagicDuck/grug-far.nvim',
    opts = { headerMaxWidth = 80 },
    cmd = { 'GrugFar', 'GrugFarWithin' },
    keys = {
      {
        '<leader>sr',
        function()
          local grug = require 'grug-far'
          local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'

          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
            },
          }
        end,
        mode = { 'n', 'x' },
        desc = 'Search and replace',
      },
    },
  },

  -- todo comments utilities
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    opts = {},
    -- stylua: ignore
    keys = {
      { ']t', function() require('todo-comments').jump_next() end, desc = "Next todo comment" },
      { '[t', function() require('todo-comments').jump_prev() end, desc = "Previous todo comment" },
      { '<leader>st', function() Snacks.picker.todo_comments() end, desc = 'Search TODOs' },
      { '<leader>sT', function() Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } } end, desc = 'Search TODO/FIX/FIXME' },
    },
  },

  -- Better navigation for search
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle flash search" },
      { "<c-space>", mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            actions = {
              ["<c-space>"] = "next",
              ["<BS>"] = "prev"
            }
          })
        end,
        desc = "Treesitter incremental selection"
      },
    },
  },

  -- Better diagnostics
  {
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
      { '<leader>xw', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Trouble workspace diagnostics' },
      { '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Trouble document diagnostics' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<CR>', desc = 'Trouble quickfix list' },
      { '<leader>xl', '<cmd>Trouble loclist toggle<CR>', desc = 'Trouble location list' },
      { '<leader>xt', '<cmd>Trouble todo toggle<CR>', desc = 'Trouble TODOs' },
      { '<leader>xT', '<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<CR>', desc = 'Trouble TODO/FIX/FIXME' },
      { '<leader>cs', '<cmd>Trouble symbols toggle<CR>', desc = 'Code symbols (Trouble)' },
      { '<leader>cL', '<cmd>Trouble lsp toggle<CR>', desc = 'Code LSP (Trouble)' },
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
    },
  },
}

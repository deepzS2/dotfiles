return {
  {
    'mrcjkb/rustaceanvim',
    ft = { 'rust' },
    opts = {
      ---@type RustaceanToolsOpts
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set({ 'n', 'x' }, 'gra', function()
            vim.cmd.RustLsp 'codeAction'
          end, { desc = '[G]oto Code [A]ction', buffer = bufnr })
          vim.keymap.set('n', '<leader>dr', function()
            vim.cmd.RustLsp 'debuggables'
          end, { desc = '[D]ebuggables', buffer = bufnr })
        end,
      },
      default_settings = {
        -- rust-analyzer language server configuration
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
          },
          -- Add clippy lints for Rust if using rust-analyzer
          checkOnSave = true,
          -- Enable diagnostics if using rust-analyzer
          diagnostics = {
            enable = true,
          },
          procMacro = {
            enable = true,
          },
          files = {
            excludeDirs = {
              '.direnv',
              '.git',
              '.github',
              '.gitlab',
              'bin',
              'node_modules',
              'target',
              'venv',
              '.venv',
            },
            -- Avoid Roots Scanned hanging, see https://github.com/rust-lang/rust-analyzer/issues/12613#issuecomment-2096386344
            watcher = 'client',
          },
        },
      },
    },
    config = function(_, opts)
      if not require('deepz.utils.mnw').is_nix then
        local codelldb = vim.fn.exepath 'codelldb'
        local codelldb_lib_ext = io.popen('uname'):read '*l' == 'Linux' and '.so' or '.dylib'
        local library_path = vim.fn.expand('$MASON/opt/lldb/lib/liblldb' .. codelldb_lib_ext)

        opts.dap = {
          adapter = require('rustaceanvim.config').get_codelldb_adapter(codelldb, library_path),
        }
      end

      vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
}

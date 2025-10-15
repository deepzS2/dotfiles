return {
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    ft = { 'rust' },
    dependencies = {
      'williamboman/mason.nvim',
    },
    opts = {
      ---@type RustaceanToolsOpts
      tools = {
        hover_actions = {
          replace_builtin_hover = false,
        },
      },
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set('n', '<leader>ca', function()
            vim.cmd.RustLsp 'codeAction'
          end, { desc = '[C]ode [A]ction', buffer = bufnr })
          vim.keymap.set('n', '<leader>dr', function()
            vim.cmd.RustLsp 'debuggables'
          end, { desc = '[D]ebuggables', buffer = bufnr })
        end,
        server = {
          cmd = function()
            local mason_registry = require 'mason-registry'

            if mason_registry.is_installed 'rust-analyzer' then
              -- This may need to be tweaked depending on the operating system.
              local ra = mason_registry.get_package 'rust-analyzer'
              local ra_filename = ra:get_receipt():get().links.bin['rust-analyzer']
              return { ('%s/%s'):format(ra:get_install_path(), ra_filename or 'rust-analyzer') }
            else
              -- global installation
              return { 'rust-analyzer' }
            end
          end,
        },
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
            ignored = {
              ['async-trait'] = { 'async_trait' },
              ['napi-derive'] = { 'napi' },
              ['async-recursion'] = { 'async_recursion' },
            },
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
          },
        },
      },
    },
    config = function(_, opts)
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

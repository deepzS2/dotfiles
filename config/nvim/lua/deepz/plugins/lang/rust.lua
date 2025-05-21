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
          vim.keymap.set('n', '<leader>cR', function()
            vim.cmd.RustLsp 'codeAction'
          end, { desc = 'Code Action', buffer = bufnr })
          vim.keymap.set('n', '<leader>dr', function()
            vim.cmd.RustLsp 'debuggables'
          end, { desc = 'Rust Debuggables', buffer = bufnr })
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
            -- Add clippy lints for Rust.
            checkOnSave = true,
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end,
  },

  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    tag = 'stable',
    opts = {
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  -- {
  --   'neovim/nvim-lspconfig',
  --   opts = {
  --     servers = {
  --       taplo = {
  --         keys = {
  --           {
  --             'K',
  --             function()
  --               if vim.fn.expand '%:t' == 'Cargo.toml' and require('crates').popup_available() then
  --                 require('crates').show_popup()
  --               else
  --                 vim.lsp.buf.hover()
  --               end
  --             end,
  --             desc = 'Show Crate Documentation',
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
}

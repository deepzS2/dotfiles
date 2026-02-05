local mnw_utils = require 'deepz.utils.mnw'

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'mini.icons', words = { 'MiniIcons' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Mason plugins: disabled when using Nix (tools come from extraBinPath)
      {
        'williamboman/mason.nvim',
        enabled = not mnw_utils.is_nix,
        opts = {},
      },
      {
        'williamboman/mason-lspconfig.nvim',
        enabled = not mnw_utils.is_nix,
        opts = {},
      },
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        enabled = not mnw_utils.is_nix,
      },

      { 'j-hui/fidget.nvim', opts = {} },
      { 'b0o/schemastore.nvim', name = 'SchemaStore.nvim' },

      {
        'rachartier/tiny-inline-diagnostic.nvim',
        event = 'LspAttach',
        priority = 1000,
        opts = {},
      },

      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grd', function()
            Snacks.picker.lsp_definitions()
          end, '[G]oto [D]efinition')

          map('grr', function()
            Snacks.picker.lsp_references()
          end, '[G]oto [R]eferences')

          map('gri', function()
            Snacks.picker.lsp_implementations()
          end, '[G]oto [I]mplementation')

          map('grt', function()
            Snacks.picker.lsp_type_definitions()
          end, '[G]o [T]ype [D]efinition')

          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          map('gO', function()
            Snacks.picker.lsp_symbols()
          end, 'Open Document Symbols')

          map('gW', function()
            Snacks.picker.lsp_symbols {
              workspace = true,
            }
          end, 'Open Workspace Symbols')

          map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })

            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = false,
      }

      local servers = {
        tailwindcss = {
          filetypes_exclude = { 'markdown' },
        },
        dockerls = {},
        taplo = {},
        docker_compose_language_service = {},
        astro = {},
        elixirls = {},
        bashls = {},
        htmx = {},
        biome = {},
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
              semanticTokens = true,
            },
          },
        },
        vtsls = {
          enabled = true,
          filetypes = {
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
            'vue',
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
              typescript = {
                updateImportsOnFileMove = { enabled = 'always' },
                suggest = {
                  completeFunctionCalls = true,
                },
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = 'literals' },
                  parameterTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  variableTypes = { enabled = false },
                },
              },
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },
        qmlls = {
          cmd = { 'qmlls', '-E' },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      -- Nixd configuration: only available when running under Nix
      if mnw_utils.is_nix then
        local nixd_cfg = vim.g.nixd_config or {}
        servers.nixd = {
          cmd = { 'nixd' },
          settings = {
            nixd = {
              nixpkgs = {
                expr = nixd_cfg.nixpkgs,
              },
              formatting = {
                command = { 'alejandra' },
              },
              options = {
                nixos = {
                  expr = nixd_cfg.nixos_expr,
                },
                home_manager = {
                  expr = nixd_cfg.home_manager_expr,
                },
                flake_parts = {
                  expr = nixd_cfg.flake_parts_expr,
                },
              },
            },
          },
        }
      else
        servers.rnix = {}
        servers.nil_ls = {}
      end

      -- Setup LSP servers
      if mnw_utils.is_nix then
        for server_name, cfg in pairs(servers) do
          vim.lsp.config(server_name, cfg)
          vim.lsp.enable(server_name)
        end
      else
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          'stylua',
          'prettierd',
          'markdownlint',
          'shellcheck',
          'shfmt',
          'hadolint',
          'alejandra',
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        for server_name, server in pairs(servers) do
          vim.lsp.enable(server)
          vim.lsp.config(server_name, server)
        end
      end
    end,
  },
}

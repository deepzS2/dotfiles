return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>bf',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[B]uffer [F]ormat',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }

      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "biome", stop_after_first = true },
      lua = { 'stylua' },
      javascript = { 'prettierd', 'biome', stop_after_first = true },
      typescript = { 'prettierd', 'biome', stop_after_first = true },
      javascriptreact = { 'prettierd', 'biome', stop_after_first = true },
      typescriptreact = { 'prettierd', 'biome', stop_after_first = true },
      json = { 'prettierd', 'biome', stop_after_first = true },
      jsonc = { 'prettierd', 'biome', stop_after_first = true },
      css = { 'prettierd', 'biome', stop_after_first = true },
      html = { 'prettierd', 'biome', stop_after_first = true },
      vue = { 'prettierd', 'biome', stop_after_first = true },
      scss = { 'prettierd', 'biome', stop_after_first = true },
      markdown = { 'prettierd', 'biome', stop_after_first = true },
      yaml = { 'prettierd', 'biome', stop_after_first = true },
      astro = { 'prettierd', 'biome', stop_after_first = true },
      go = { 'goimports', 'gofumpt' },
      shell = { 'shfmt' },
    },
  },
}

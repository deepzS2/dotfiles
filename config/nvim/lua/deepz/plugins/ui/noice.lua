return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
  },
  opts = {
    presets = {
      lsp_doc_border = true,
    },
    messages = {
      enabled = false,
    },
  },
}

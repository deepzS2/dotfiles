return {
  -- Collection of QoL plugins
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = {
    {
      'folke/persistence.nvim',
      event = 'BufReadPre', -- this will only start session saving when an actual file was opened
      opts = {
        -- add any custom options here
      },
    },
  },
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
        {
          pane = 2,
          section = 'terminal',
          cmd = 'colorscript -e square',
          height = 5,
          padding = 1,
        },
        { section = 'keys', gap = 1, padding = 1 },
        { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        {
          pane = 2,
          icon = ' ',
          title = 'Git Status',
          section = 'terminal',
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = 'git status --short --branch --renames',
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = 'startup' },
      },
    },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        relative = 'editor',
        wo = { wrap = true }, -- Wrap notifications
      },
    },
  },
  keys = {
    -- Zen
    {
      '<leader>z',
      function()
        Snacks.zen()
      end,
      desc = 'Toggle [Z]en Mode',
    },
    {
      '<leader>Z',
      function()
        Snacks.zen.zoom()
      end,
      desc = 'Toggle [Z]oom',
    },

    -- Scratch
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select [S]cratch Buffer',
    },

    -- Notifier
    {
      '<leader>nh',
      function()
        Snacks.notifier.show_history()
      end,
      desc = '[N]otification [H]istory',
    },
    {
      '<leader>nD',
      function()
        Snacks.notifier.hide()
      end,
      desc = '[N]otifications [D]ismiss All',
    },

    -- Buffer delete
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = '[B]uffer [D]elete',
    },

    -- Git and LazyGit
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = '[G]it [B]rowse',
    },
    {
      '<leader>gb',
      function()
        Snacks.git.blame_line()
      end,
      desc = '[G]it [B]lame Line',
    },
    {
      '<leader>go',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazy[G]it [O]pen',
    },
    {
      '<leader>gf',
      function()
        Snacks.lazygit.log_file()
      end,
      desc = 'Lazy[G]it [F]ile Log',
    },
    {
      '<leader>gl',
      function()
        Snacks.lazygit.log()
      end,
      desc = 'Lazy[G]it [L]og',
    },

    -- Words
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },

    -- Picker
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>sn',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.grep()
      end,
      desc = '[/] Fuzzily search in current buffer',
    },
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = '[S]earch [R]egisters',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.recent()
      end,
      desc = '[S]earch [R]ecent files',
    },
    {
      '<leader>sR',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>,',
      function()
        Snacks.picker.buffers()
      end,
      desc = '[,] Search buffers',
    },
    {
      '<leader>sb',
      function()
        Snacks.picker.lines()
      end,
      desc = '[S]earch [B]uffer lines',
    },
    {
      '<leader>sB',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = '[S]earch Grep Open [B]uffers',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[S]earch [G]rep',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[S]earch current [W]ord',
      mode = { 'n', 'x' },
    },
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist()
      end,
      desc = '[S]earch [Q]uickfix List',
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
  end,
}

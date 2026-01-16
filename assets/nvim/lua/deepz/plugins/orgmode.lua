return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  dependencies = {
    'chipsenkbeil/org-roam.nvim',
    'MeanderingProgrammer/render-markdown.nvim',
    'akinsho/org-bullets.nvim',
    { 'michaelb/sniprun', build = 'sh install.sh', opts = {} },
  },
  keys = {
    {
      '<leader>ob',
      function()
        require('deepz.plugins.org.babel').snip_org_run()
      end,
      ft = 'org',
      desc = '[O]rg [B]abel Run',
    },

    -- Org-Roam Core (<leader>oR prefix)
    {
      '<leader>oRf',
      function()
        local lines = require('org-roam').utils.get_visual_selection { single_line = true }
        local title = lines[1] or ''
        require('org-roam').api.find_node { title = title }
      end,
      desc = '[O]rg [R]oam [F]ind Node',
    },
    {
      '<leader>oRi',
      function()
        local lines, ranges = require('org-roam').utils.get_visual_selection { single_line = true }
        local title = lines[1] or ''
        require('org-roam').api.insert_node { title = title, ranges = ranges }
      end,
      ft = 'org',
      desc = '[O]rg [R]oam [I]nsert Node',
    },
    {
      '<leader>oRb',
      function()
        require('org-roam').ui.open_quickfix_list {
          backlinks = true,
          show_preview = true,
        }
      end,
      ft = 'org',
      desc = '[O]rg [R]oam [B]acklinks',
    },
    {
      '<leader>oRn',
      function()
        require('org-roam').api.goto_next_node()
      end,
      ft = 'org',
      desc = '[O]rg [R]oam [N]ext Node',
    },
    {
      '<leader>oRp',
      function()
        require('org-roam').api.goto_prev_node()
      end,
      ft = 'org',
      desc = '[O]rg [R]oam [P]rev Node',
    },
    {
      '<leader>oR.',
      function()
        require('org-roam').api.complete_node()
      end,
      ft = 'org',
      desc = '[O]rg [R]oam Complete',
    },

    -- Org-Roam Alias (<leader>oRa prefix)
    {
      '<leader>oRaa',
      function()
        require('org-roam').api.add_alias()
      end,
      ft = 'org',
      desc = '[O]rg [R]oam [A]lias [A]dd',
    },
    {
      '<leader>oRar',
      function()
        require('org-roam').api.remove_alias()
      end,
      ft = 'org',
      desc = '[O]rg [R]oam [A]lias [R]emove',
    },

    -- Org-Roam Origin (<leader>oRo prefix)
    {
      '<leader>oRoa',
      function()
        require('org-roam').api.add_origin()
      end,
      ft = 'org',
      desc = '[O]rg [R]oam [O]rigin [A]dd',
    },
    {
      '<leader>oRor',
      function()
        require('org-roam').api.remove_origin()
      end,
      ft = 'org',
      desc = '[O]rg [R]oam [O]rigin [R]emove',
    },

    -- Org-Roam Dailies (<leader>od prefix)
    {
      '<leader>odn',
      function()
        require('org-roam').ext.dailies.goto_today()
      end,
      desc = '[O]rg [D]aily Today',
    },
    {
      '<leader>odN',
      function()
        require('org-roam').ext.dailies.capture_today()
      end,
      desc = '[O]rg [D]aily Capture Today',
    },
    {
      '<leader>odt',
      function()
        require('org-roam').ext.dailies.goto_tomorrow()
      end,
      desc = '[O]rg [D]aily [T]omorrow',
    },
    {
      '<leader>ody',
      function()
        require('org-roam').ext.dailies.goto_yesterday()
      end,
      desc = '[O]rg [D]aily [Y]esterday',
    },
    {
      '<leader>odd',
      function()
        require('org-roam').ext.dailies.goto_date()
      end,
      desc = '[O]rg [D]aily Go to [D]ate',
    },
    {
      '<leader>odD',
      function()
        require('org-roam').ext.dailies.capture_date()
      end,
      desc = '[O]rg [D]aily Capture Date',
    },
    {
      '<leader>odf',
      function()
        require('org-roam').ext.dailies.goto_next_date()
      end,
      desc = '[O]rg [D]aily [F]orward',
    },
    {
      '<leader>odb',
      function()
        require('org-roam').ext.dailies.goto_prev_date()
      end,
      desc = '[O]rg [D]aily [B]ack',
    },

    -- Org Search
    {
      '<leader>os',
      function()
        Snacks.picker.grep { cwd = '~/notes' }
      end,
      desc = '[O]rg [S]earch',
    },

    -- Insert mode roam link
    {
      '<C-l>',
      function()
        local lines, ranges = require('org-roam').utils.get_visual_selection { single_line = true }
        local title = lines[1] or ''
        require('org-roam').api.insert_node { title = title, ranges = ranges, immediate = true }
      end,
      mode = 'i',
      desc = 'Insert Roam Link',
    },
  },
  config = function()
    require('orgmode').setup {
      org_agenda_files = { '~/notes/**/*' },
      org_default_notes_file = '~/notes/refile.org',
      mappings = {
        prefix = '<leader>o',
        global = {
          org_agenda = { 'gA', '<leader>oa', desc = '[O]rg [A]genda' },
          org_capture = { 'gC', '<leader>oc', desc = '[O]rg [C]apture' },
        },
        org = {
          -- Navigation
          org_next_visible_heading = { '}', desc = 'Next Visible Heading' },
          org_previous_visible_heading = { '{', desc = 'Prev Visible Heading' },
          org_forward_heading_same_level = { ']]', desc = 'Forward Heading Same Level' },
          org_backward_heading_same_level = { '[[', desc = 'Backward Heading Same Level' },
          outline_up_heading = { 'g{', desc = 'Up to Parent Heading' },

          -- Heading/Subtree manipulation
          org_move_subtree_up = { 'gK', desc = 'Move Subtree Up' },
          org_move_subtree_down = { 'gJ', desc = 'Move Subtree Down' },
          org_do_promote = { '<<', desc = 'Promote Heading' },
          org_do_demote = { '>>', desc = 'Demote Heading' },
          org_promote_subtree = { '<s', desc = 'Promote Subtree' },
          org_demote_subtree = { '>s', desc = 'Demote Subtree' },
          org_meta_return = { '<leader><CR>', desc = '[O]rg Meta Return' },

          -- TODO/Priority
          org_todo = { 'cit', desc = 'TODO Next State' },
          org_todo_prev = { 'ciT', desc = 'TODO Prev State' },
          org_priority_up = { 'ciR', desc = 'Priority Up' },
          org_priority_down = { 'cir', desc = 'Priority Down' },
          org_set_tags_command = { '<prefix>t', desc = '[O]rg Set [T]ags' },
          org_toggle_heading = { '<prefix>*', desc = '[O]rg Toggle Heading' },
          org_toggle_checkbox = { '<C-Space>', desc = 'Toggle Checkbox' },

          -- Timestamps
          org_change_date = { 'cid', desc = 'Change Date' },
          org_timestamp_up = { '<C-a>', desc = 'Timestamp Up' },
          org_timestamp_down = { '<C-x>', desc = 'Timestamp Down' },
          org_timestamp_up_day = { '<S-Up>', desc = 'Timestamp Up Day' },
          org_timestamp_down_day = { '<S-Down>', desc = 'Timestamp Down Day' },
          org_toggle_timestamp_type = { '<prefix>!', desc = '[O]rg Toggle Timestamp Type' },

          -- Insert
          org_insert_heading_respect_content = { '<prefix>ih', desc = '[O]rg [I]nsert [H]eading' },
          org_insert_todo_heading = { '<prefix>iT', desc = '[O]rg [I]nsert [T]ODO Heading' },
          org_insert_todo_heading_respect_content = { '<prefix>it', desc = '[O]rg [I]nsert [t]odo Heading' },
          org_insert_link = { '<prefix>il', desc = '[O]rg [I]nsert [L]ink' },
          org_deadline = { '<prefix>id', desc = '[O]rg [I]nsert [D]eadline' },
          org_schedule = { '<prefix>is', desc = '[O]rg [I]nsert [S]chedule' },
          org_time_stamp = { '<prefix>i.', desc = '[O]rg [I]nsert Timestamp' },
          org_time_stamp_inactive = { '<prefix>i!', desc = '[O]rg [I]nsert Timestamp (Inactive)' },
          org_add_note = { '<prefix>in', desc = '[O]rg [I]nsert [N]ote' },

          -- Clock
          org_clock_in = { '<prefix>xi', desc = '[O]rg Cloc[x] [I]n' },
          org_clock_out = { '<prefix>xo', desc = '[O]rg Cloc[x] [O]ut' },
          org_clock_cancel = { '<prefix>xq', desc = '[O]rg Cloc[x] Cancel' },
          org_clock_goto = { '<prefix>xj', desc = '[O]rg Cloc[x] [J]ump' },
          org_set_effort = { '<prefix>xe', desc = '[O]rg Cloc[x] [E]ffort' },

          -- Other
          org_open_at_point = { '<prefix>o', desc = '[O]rg [O]pen at Point' },
          org_archive_subtree = { '<prefix>$', desc = '[O]rg Archive Subtree' },
          org_toggle_archive_tag = { '<prefix>A', desc = '[O]rg Toggle [A]rchive Tag' },
          org_export = { '<prefix>E', desc = '[O]rg [E]xport' },
          org_babel_tangle = { '<prefix>T', desc = '[O]rg [T]angle' },
          org_refile = { '<prefix>r', desc = '[O]rg [R]efile' },
          org_store_link = { '<prefix>l', desc = '[O]rg Store [L]ink' },

          -- Folding
          org_cycle = { '<Tab>', desc = 'Cycle Fold' },
          org_global_cycle = { '<S-Tab>', desc = 'Global Cycle Fold' },
        },
        agenda = {
          org_agenda_add_note = { '<prefix>nn', desc = '[O]rg [N]ew [N]ote' },
        },
      },
    }

    require('org-roam').setup {
      directory = '~/notes',
      bindings = false,
      extensions = {
        dailies = {
          bindings = false,
          directory = 'daily',
          templates = {
            {
              description = 'default',
              template = '%?',
              target = '%<%Y-%m-%d>.org',
            },
          },
        },
      },
    }

    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    require('render-markdown').setup {
      file_types = { 'markdown', 'org' },
      indent = {
        enabled = true,
      },
    }

    require('org-bullets').setup {
      list = '•',
      headlines = { '◉', '○', '✸', '✿' },
      checkboxes = {
        half = { '', '@org.checkbox.halfchecked' },
        done = { '✓', '@org.keyword.done' },
        todo = { '˟', '@org.keyword.todo' },
      },
    }
  end,
}

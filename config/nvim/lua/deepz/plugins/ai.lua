return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/codecompanion-history.nvim',
    { 'zbirenbaum/copilot.lua', opts = {} },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'codecompanion' },
      },
      ft = { 'markdown', 'codecompanion' },
    },
    {
      'HakonHarnes/img-clip.nvim',
      opts = {
        filetypes = {
          codecompanion = {
            prompt_for_file_name = false,
            template = '[Image]($FILE_PATH)',
            use_absolute_path = true,
          },
        },
      },
    },
  },
  keys = {
    {
      '<leader>aa',
      '<Cmd>CodeCompanionActions<CR>',
      desc = '[A]I [A]ctions',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ac',
      '<Cmd>CodeCompanionChat Toggle<CR>',
      desc = '[A]I [C]hat',
    },
    {
      '<leader>ai',
      '<Cmd>CodeCompanion<CR>',
      desc = '[A]I [I]nline',
      mode = { 'n', 'x' },
    },
    {
      '<leader>ah',
      '<Cmd>CodeCompanionHistory<CR>',
      desc = '[A]I [H]istory',
    },
  },
  opts = {
    display = {
      action_palette = {
        width = 95,
        height = 10,
        prompt = 'Prompt ', -- Prompt used for interactive LLM calls
        provider = 'snacks', -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
        opts = {
          show_default_actions = true, -- Show the default actions in the action palette?
          show_default_prompt_library = true, -- Show the default prompt library in the action palette?
        },
      },
      diff = {
        enabled = true,
        close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
        layout = 'vertical', -- vertical|horizontal split for default provider
        opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
        provider = 'mini_diff', -- default|mini_diff
      },
    },
    adapters = {
      copilot = function()
        return require('codecompanion.adapters').extend('copilot', {
          schema = {
            model = {
              default = 'gemini-2.5-pro',
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = 'copilot',
      },
      inline = {
        adapter = 'copilot',
      },
    },
    prompt_library = {
      ['Generate message and commit'] = {
        strategy = 'chat',
        description = 'Generate a message and then executes the commit',
        opts = {
          short_name = 'git_commit',
          auto_submit = true,
        },
        prompts = {
          {
            role = 'user',
            content = function()
              return string.format(
                [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me and then use @cmd_runner tool to create the commit:

                    ```diff
                    %s
                    ```
                    ]],
                vim.fn.system 'git diff --no-ext-diff --staged'
              )
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
    },
    extensions = {
      history = {
        enabled = true,
        opts = {
          -- Keymap to open history from chat buffer (default: gh)
          keymap = 'gh',
          -- Keymap to save the current chat manually (when auto_save is disabled)
          save_chat_keymap = 'sc',
          -- Save all chats by default (disable to save only manually using 'sc')
          auto_save = true,
          -- Number of days after which chats are automatically deleted (0 to disable)
          expiration_days = 0,
          -- Picker interface ("telescope" or "snacks" or "fzf-lua" or "default")
          picker = 'snacks',
          ---Automatically generate titles for new chats
          auto_generate_title = true,
          title_generation_opts = {
            ---Adapter for generating titles (defaults to active chat's adapter)
            adapter = nil, -- e.g "copilot"
            ---Model for generating titles (defaults to active chat's model)
            model = nil, -- e.g "gpt-4o"
          },
          ---On exiting and entering neovim, loads the last chat on opening chat
          continue_last_chat = false,
          ---When chat is cleared with `gx` delete the chat from history
          delete_on_clearing_chat = false,
          ---Directory path to save the chats
          dir_to_save = vim.fn.stdpath 'data' .. '/codecompanion-history',
          ---Enable detailed logging for history extension
          enable_logging = false,
        },
      },
    },
  },
}

-- return {
--   'yetone/avante.nvim',
--   event = 'VeryLazy',
--   version = false, -- Never set this value to "*"! Never!
--   opts = {
--     provider = 'copilot',
--     copilot = {
--       model = 'claude-3.7-sonnet', -- Default model
--     },
--   },
--   dependencies = {
--     'nvim-treesitter/nvim-treesitter',
--     'stevearc/dressing.nvim',
--     'nvim-lua/plenary.nvim',
--     'MunifTanjim/nui.nvim',
--     --- The below dependencies are optional,
--     -- 'echasnovski/mini.pick', -- for file_selector provider mini.pick
--     -- 'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
--     -- 'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
--     'ibhagwan/fzf-lua', -- for file_selector provider fzf
--     -- 'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
--     { 'zbirenbaum/copilot.lua', opts = {} }, -- for providers='copilot'
--     {
--       -- support for image pasting
--       'HakonHarnes/img-clip.nvim',
--       event = 'VeryLazy',
--       opts = {
--         -- recommended settings
--         default = {
--           embed_image_as_base64 = false,
--           prompt_for_file_name = false,
--           drag_and_drop = {
--             insert_mode = true,
--           },
--           -- required for Windows users
--           use_absolute_path = true,
--         },
--       },
--     },
--     {
--       -- Make sure to set this up properly if you have lazy=true
--       'MeanderingProgrammer/render-markdown.nvim',
--       opts = {
--         file_types = { 'markdown', 'Avante' },
--       },
--       ft = { 'markdown', 'Avante' },
--     },
--   },
--   config = function(_, opts)
--     local available_models = {
--       ['claude-3.7-sonnet'] = { model = 'claude-3.7-sonnet' },
--       ['claude-3.7-sonnet🙅‍♂️🛠️'] = { model = 'claude-3.7-sonnet', disable_tools = true },
--       ['claude-3.5-sonnet'] = { model = 'claude-3.5-sonnet' },
--       ['o3-mini-high'] = { model = 'o3-mini', reasoning_effort = 'high' },
--       ['o4-mini-high'] = { model = 'o4-mini', reasoning_effort = 'high' },
--       ['o4-mini-high🙅‍♂️🛠️'] = { model = 'o4-mini', reasoning_effort = 'high', disable_tools = true },
--       ['o3-mini'] = { model = 'o3-mini' },
--       ['o4-mini'] = { model = 'o4-mini' },
--       ['4o'] = { model = 'gpt-4o' },
--       ['4.1'] = { model = 'gpt-4.1' },
--       ['4.1🙅‍♂️🛠️'] = { model = 'gpt-4.1', disable_tools = true },
--       ['4.1-mini'] = { model = 'gpt-4.1-mini' },
--       ['gemini-2.5-pro'] = { model = 'gemini-2.5-pro' },
--       ['gemini-2.5-pro🙅‍♂️🛠️'] = { model = 'gemini-2.5-pro', disable_tools = true },
--       ['gemini-2.0-flash'] = { model = 'gemini-2.0-flash' },
--       ['o2'] = { model = 'o2' },
--       ['o3'] = { model = 'o3' },
--       ['o1'] = { model = 'o1', reasoning_effort = 'high' },
--     }
--
--     local function switch_model()
--       local model_keys = vim.tbl_keys(available_models)
--       vim.ui.select(model_keys, { prompt = 'Select Avante Model:' }, function(selected)
--         if selected then
--           opts.copilot = available_models[selected]
--           require('avante').setup(opts)
--           print('Switched Copilot model to: ' .. selected)
--         else
--           print 'Model selection canceled.'
--         end
--       end)
--     end
--
--     vim.keymap.set('n', '<leader>am', switch_model, { desc = '[A]vante: Switch Copilot [M]odel' })
--
--     require('avante').setup(opts)
--   end,
-- }

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/codecompanion-history.nvim',
    'j-hui/fidget.nvim',
    { 'zbirenbaum/copilot.lua', opts = {} },
    {
      'OXY2DEV/markview.nvim',
      lazy = false,
      priority = 49,
      opts = function()
        local function conceal_tag(icon, hl_group)
          return {
            on_node = { hl_group = hl_group },
            on_closing_tag = { conceal = '' },
            on_opening_tag = {
              conceal = '',
              virt_text_pos = 'inline',
              virt_text = { { icon .. ' ', hl_group } },
            },
          }
        end

        return {
          preview = {
            filetypes = { 'markdown', 'codecompanion' },
            ignore_buftypes = {},
          },
          html = {
            container_elements = {
              ['^buf$'] = conceal_tag('', 'CodeCompanionChatVariable'),
              ['^file$'] = conceal_tag('', 'CodeCompanionChatVariable'),
              ['^help$'] = conceal_tag('󰘥', 'CodeCompanionChatVariable'),
              ['^image$'] = conceal_tag('', 'CodeCompanionChatVariable'),
              ['^symbols$'] = conceal_tag('', 'CodeCompanionChatVariable'),
              ['^url$'] = conceal_tag('󰖟', 'CodeCompanionChatVariable'),
              ['^var$'] = conceal_tag('', 'CodeCompanionChatVariable'),
              ['^tool$'] = conceal_tag('', 'CodeCompanionChatTool'),
              ['^user_prompt$'] = conceal_tag('', 'CodeCompanionChatTool'),
              ['^group$'] = conceal_tag('', 'CodeCompanionChatToolGroup'),
            },
          },
        }
      end,
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
    {
      'Davidyz/VectorCode',
      name = 'vectorcode.nvim',
      version = '*', -- optional, depending on whether you're on nightly or release
      dependencies = { 'nvim-lua/plenary.nvim' },
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
      '<Cmd>CodeCompanionChat<CR>',
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
    {
      '<leader>ag',
      function()
        require('codecompanion').prompt 'commit'
      end,
      desc = '[A]I [G]it commit',
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
        roles = {
          --- The header name for your messages
          ---@type string
          user = 'deepz',
        },
        keymaps = {
          send = {
            callback = function(chat)
              vim.cmd 'stopinsert'
              chat:submit()
              chat:add_buf_message { role = 'llm', content = '' }
            end,
            index = 1,
            description = 'Send',
          },
        },
        slash_commands = {
          ['file'] = {
            opts = {
              provider = 'snacks',
            },
          },
          ['buffer'] = {
            opts = {
              provider = 'snacks',
            },
          },
        },
        opts = {
          completion_provider = 'blink',
        },
      },
      inline = {
        adapter = 'copilot',
      },
    },
    prompt_library = {
      ['Generate a Commit Message'] = {
        strategy = 'chat',
        description = 'Generate a commit message',
        opts = {
          is_slash_cmd = true,
          short_name = 'commit',
          auto_submit = true,
        },
        prompts = {
          {
            role = 'user',
            content = function()
              return string.format(
                [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me and then use @{cmd_runner} tool to create the commit:

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
      vectorcode = {
        opts = {
          add_tool = true,
        },
      },
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
  config = function(_, opts)
    require('deepz.plugins.codecompanion.spinner'):init()

    require('codecompanion').setup(opts)
  end,
}

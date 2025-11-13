local M = {
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
}

return M

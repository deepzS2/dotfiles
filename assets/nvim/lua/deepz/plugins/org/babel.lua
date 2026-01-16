local sa = require 'sniprun.api'

local M = {}

-- Configuration for org-mode code block parsing
M.config = {
  parse_pattern = {
    code_opening = [[\v^#\+(BEGIN_SRC|begin_src)]],
    code_closing = [[\v^#\+(END_SRC|end_src)]],
    -- #+RESULTS is an affiliated keyword
    -- it can precede any element, except those listed in the manual
    -- https://orgmode.org/worg/dev/org-syntax.html#Affiliated_keywords
    result_opening = [[\v^#\+(RESULTS|results):]],
    result_closing = [[^\(\([:|]\|#+END_\).*\)\?\n\([:|]\s\?\)\@!]],
  },
  result_block_name = '#+RESULTS:',
  -- Map org-mode language names to sniprun filetypes
  lang_map = {
    python = 'python',
    python3 = 'python',
    py = 'python',
    lua = 'lua',
    javascript = 'javascript',
    js = 'javascript',
    typescript = 'typescript',
    ts = 'typescript',
    rust = 'rust',
    rs = 'rust',
    go = 'go',
    golang = 'go',
    bash = 'bash',
    sh = 'bash',
    shell = 'bash',
    zsh = 'bash',
    ruby = 'ruby',
    rb = 'ruby',
    c = 'c',
    cpp = 'cpp',
    ['c++'] = 'cpp',
    java = 'java',
    julia = 'julia',
    r = 'r',
    R = 'r',
    haskell = 'haskell',
    hs = 'haskell',
    clojure = 'clojure',
    clj = 'clojure',
    scala = 'scala',
    php = 'php',
    perl = 'perl',
    sql = 'sql',
    ocaml = 'ocaml',
    ml = 'ocaml',
    elixir = 'elixir',
    d = 'd',
    ada = 'ada',
    coffeescript = 'coffeescript',
    coffee = 'coffeescript',
    fsharp = 'fsharp',
    ['f#'] = 'fsharp',
    csharp = 'cs',
    ['c#'] = 'cs',
    cs = 'cs',
    mathematica = 'mathematica',
    sage = 'sage',
  },
}

-- Module state for async callback (required due to sniprun's callback API)
local pending_block = nil
local original_display = nil

---Extract language from #+BEGIN_SRC line
---@param line_nr number Line number of the BEGIN_SRC line
---@return string|nil Language name, or nil if not found
local function extract_language(line_nr)
  local line = vim.fn.getline(line_nr)
  -- Match #+BEGIN_SRC <lang> or #+begin_src <lang>
  local lang = line:match('^#%+[Bb][Ee][Gg][Ii][Nn]_[Ss][Rr][Cc]%s+(%S+)')
  if lang then
    -- Remove any additional parameters (e.g., `:results output`)
    lang = lang:match('^([^%s:]+)')
    return lang and lang:lower()
  end
  return nil
end

---Get sniprun filetype from org-mode language name
---@param lang string Org-mode language name
---@return string Sniprun filetype
local function get_filetype(lang)
  return M.config.lang_map[lang] or lang
end

---Parse an org-mode block bounded by opening/closing patterns
---@param opening string Vim regex pattern for block start
---@param closing string Vim regex pattern for block end
---@return {blk_beg_line_nr: number, blk_end_line_nr: number}|nil
local function parse_block(opening, closing)
  local save_cursor = vim.fn.getpos '.'

  -- Search backward for block beginning
  local blk_beg_line_nr = vim.fn.search(opening, 'bcW')
  if blk_beg_line_nr == 0 then
    return nil
  end

  -- Search forward for block end
  local blk_end_line_nr = vim.fn.search(closing, 'nW')
  if blk_end_line_nr == 0 then
    return nil
  end

  -- Restore cursor position
  vim.fn.setpos('.', save_cursor)

  -- Verify cursor is actually inside the block
  if blk_end_line_nr < save_cursor[2] then
    return nil
  end

  return {
    blk_beg_line_nr = blk_beg_line_nr,
    blk_end_line_nr = blk_end_line_nr,
  }
end

---Format result lines with org-mode fixed-width prefix
---@param result string Raw result string
---@return string[] Formatted lines with ': ' prefix
local function format_result_lines(result)
  local lines = vim.fn.split(result, '\n')
  for i = 1, #lines do
    lines[i] = ': ' .. lines[i]
  end
  return lines
end

---Remove existing result block if present
---@param after_line number Line number after which to search for results
local function remove_existing_results(after_line)
  vim.fn.setpos('.', { 0, after_line, 1, 0 })
  vim.fn.search([[\S]], 'W')

  local result_block = parse_block(M.config.parse_pattern.result_opening, M.config.parse_pattern.result_closing)

  if result_block then
    vim.fn.deletebufline(vim.fn.bufname(), result_block.blk_beg_line_nr, result_block.blk_end_line_nr)
  end
end

---Ensure blank line exists at position if needed
---@param line_nr number Line number to check
---@param insert_after number Line after which to insert blank
local function ensure_blank_line(line_nr, insert_after)
  if vim.fn.getline(line_nr) ~= '' then
    vim.fn.append(insert_after, '')
  end
end

---Insert execution result after a code block
---@param result string The execution result
---@param code_blk {blk_beg_line_nr: number, blk_end_line_nr: number} Code block bounds
local function insert_result(result, code_blk)
  local lines = format_result_lines(result)
  local save_cursor = vim.fn.getpos '.'
  local end_line = code_blk.blk_end_line_nr

  -- Remove any existing results
  remove_existing_results(end_line + 1)

  -- Ensure blank line after code block
  ensure_blank_line(end_line + 1, end_line)

  -- Insert #+RESULTS: header
  vim.fn.append(end_line + 1, M.config.result_block_name)

  -- Insert result lines
  if #lines > 0 then
    vim.fn.append(end_line + 2, lines)
  end

  -- Ensure blank line after results
  local results_end = end_line + 2 + #lines
  ensure_blank_line(results_end + 1, results_end)

  vim.fn.setpos('.', save_cursor)
end

---Handle sniprun API callback
---@param response {status: string, message: string}
local function handle_sniprun_response(response)
  vim.print '[babel] Handling sniprun response'

  -- Restore display config
  if original_display then
    require('sniprun').config_values.display = original_display
    original_display = nil
  end

  if not pending_block then
    return
  end

  local block = pending_block
  pending_block = nil

  if response.status == 'ok' then
    insert_result(response.message, block)
  elseif response.status == 'error' then
    vim.notify('Sniprun error: ' .. response.message, vim.log.levels.ERROR)
  end
end

---Execute the org-mode code block under cursor
function M.snip_org_run()
  local code_blk = parse_block(M.config.parse_pattern.code_opening, M.config.parse_pattern.code_closing)

  if not code_blk then
    vim.notify('Not in a code block', vim.log.levels.WARN)
    return
  end

  -- Extract language from BEGIN_SRC line
  local lang = extract_language(code_blk.blk_beg_line_nr)
  if not lang then
    vim.notify('Could not detect language from code block', vim.log.levels.ERROR)
    return
  end

  local filetype = get_filetype(lang)

  -- Calculate inner code range (excluding BEGIN_SRC and END_SRC lines)
  local code_start = code_blk.blk_beg_line_nr + 1
  local code_end = code_blk.blk_end_line_nr - 1

  if code_start > code_end then
    vim.notify('Empty code block', vim.log.levels.WARN)
    return
  end

  -- Store block for async callback
  pending_block = code_blk

  -- Configure sniprun to use API output only
  local sniprun = require 'sniprun'

  -- Store original display to restore in callback
  original_display = vim.deepcopy(sniprun.config_values.display)
  sniprun.config_values.display = { 'Api' }

  -- Run the inner code with the detected filetype
  local run_ok, err = pcall(sa.run_range, code_start, code_end, filetype, sniprun.config_values)

  if not run_ok then
    -- Restore immediately on error
    sniprun.config_values.display = original_display
    original_display = nil
    pending_block = nil
    vim.notify('Sniprun execution failed: ' .. tostring(err), vim.log.levels.ERROR)
  end
end

sa.register_listener(handle_sniprun_response)

return M

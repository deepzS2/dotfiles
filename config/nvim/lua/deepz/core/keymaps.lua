-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit insert mode
vim.keymap.set('i', 'kj', '<Esc>')

-- Increment/decrement
vim.keymap.set('n', '+', '<C-a>')
vim.keymap.set('n', '-', '<C-x>')

-- Delete without yank
vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>d', '"_d')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.get_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.get_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Save file
vim.keymap.set('n', '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })
vim.keymap.set('i', '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

-- Split window
vim.keymap.set('n', '<leader>wh', '<C-W>s', { desc = '[W]indow Split [H]orizontal', remap = true })
vim.keymap.set('n', '<leader>wv', '<C-W>v', { desc = '[W]indow Split [V]ertical', remap = true })
vim.keymap.set('n', '<leader>wx', '<C-W>c', { desc = '[W]indow Close [X]', remap = true })

-- Buffers
vim.keymap.set('n', '<leader>bn', '<cmd> enew <CR>', { desc = '[B]uffer [N]ew', noremap = true, silent = true })

-- Delete single line without copying to register
vim.keymap.set('n', 'x', '"_x', { noremap = true, silent = true })

-- Vertical scroll and center
-- vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true, silent = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true, silent = true })

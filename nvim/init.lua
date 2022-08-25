-- =========================================================
-- Startup
-- =========================================================

vim.cmd([[
  if has('vim_starting') && has('reltime')
    let g:startuptime = reltime()
  endif
]])

-- =========================================================
-- Key Mapping
-- =========================================================

-- ======== Normal/Visual Cursor Move ========

-- Wrap start/end of lines by cursor keys
vim.api.nvim_set_option('whichwrap', 'b,s,<,>,[,]')
-- Wrap start/end of lines by h and l keys
vim.keymap.set('n', 'h', '<Left>')
vim.keymap.set('n', 'l', '<Right>')
vim.keymap.set('x', 'h', '<Left>')
vim.keymap.set('x', 'l', '<Right>')

-- Move up/down with display lines
vim.keymap.set('n', 'j', 'gj', { silent = true })
vim.keymap.set('n', 'k', 'gk', { silent = true })
vim.keymap.set('x', 'j', 'gj', { silent = true })
vim.keymap.set('x', 'k', 'gk', { silent = true })
vim.keymap.set('n', 'gj', 'j', { silent = true })
vim.keymap.set('n', 'gk', 'k', { silent = true })
vim.keymap.set('x', 'gj', 'j', { silent = true })
vim.keymap.set('x', 'gk', 'k', { silent = true })

-- Move to start/end of lines
vim.keymap.set('n', 'H', '^')
vim.keymap.set('n', 'L', '$')
vim.keymap.set('x', 'H', '^')
vim.keymap.set('x', 'L', '$')

-- ======== Insert/Commnad Cursor Move ========
vim.keymap.set('i', '<C-a>', '<C-o>_')
vim.keymap.set('i', '<C-e>', '<End>')
vim.keymap.set('i', '<C-f>', '<Right>')
vim.keymap.set('i', '<C-b>', '<Left>')
vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-e>', '<End>')
vim.keymap.set('c', '<C-n>', '<Down>')
vim.keymap.set('c', '<C-p>', '<Up>')
vim.keymap.set('c', '<Down>', '<C-n>')
vim.keymap.set('c', '<Up>', '<C-p>')

-- ======== Tab Control ========
vim.api.nvim_set_option('showtabline', 2)
vim.keymap.set('n', '<C-j>', 'gt')
vim.keymap.set('n', '<C-k>', 'gT')

-- ======== Misc ========
-- Disable dangerous/unnecessary keys
vim.keymap.set('n', 'ZZ', '<Nop>')  -- danger
vim.keymap.set('n', 'ZQ', '<Nop>')  -- danger
vim.keymap.set('n', '<F1>', '<Nop>')  -- show help
vim.keymap.set('n', 'S', '<Nop>')  -- `S` == `cc`

-- Cut right of cursor
vim.keymap.set('i', '<C-k>', '<C-g>u<C-\\><C-o>D')
vim.keymap.set('c', '<C-k>', '<C-g>u<C-\\><C-o>D')

-- Copy/Paset/Cut from/to clipboard
vim.keymap.set('i', '<C-v>', '<C-o>:set paste<CR><C-r>+<C-o>:set nopaste<CR>')
vim.keymap.set('i', '<A-v>', '<C-v>')
vim.keymap.set('i', '<C-z>', '<C-v>')
vim.keymap.set('c', '<C-v>', '<C-r>+')
vim.keymap.set('c', '<A-v>', '<C-v>')
vim.keymap.set('c', '<C-z>', '<C-v>')
vim.keymap.set('x', '<C-c>', '"+y')
vim.keymap.set('x', '<C-x>', '"+d')
vim.keymap.set('x', '<C-v>', '"+p')

-- Use C-q to do what C-v used to do
vim.keymap.set('n', '<C-q>', '<C-v>')

-- ======== Command Mapping ========

-- Clear highlighting search word
vim.keymap.set('n', '<Esc><Esc>', ':<C-u>nohl<CR><C-l>')
vim.keymap.set('n', '<C-l>', ':<C-u>nohl<CR><C-l>')

-- =========================================================
-- Post Process
-- =========================================================
vim.cmd([[
  if has('vim_starting') && has('reltime')
    autocmd VimEnter * echomsg 'startuptime: ' . reltimestr(reltime(g:startuptime))
  endif
]])

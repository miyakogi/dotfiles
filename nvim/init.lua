-- =========================================================
-- Startup
-- =========================================================

-- Start mesurement
vim.cmd([[
  if has('vim_starting') && has('reltime')
    let g:startuptime = reltime()
  endif
]])

-- Create deafult auto group
vim.api.nvim_create_augroup('init', {})


-- =========================================================
-- Set Global Options
-- =========================================================

-- Disable default plugins
vim.g.loaded_gzip = 1
vim.g.loaded_LogiPat = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zipPlugin = 1


-- =========================================================
-- Set Global Options
-- =========================================================

-- Reload when file modified outfside nvim
vim.opt.autoread = true

-- Disable default files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.backupdir = ''
vim.opt.undofile = false
vim.opt.swapfile = false

-- Background buffer setting
vim.opt.hidden = true

-- Wildmenu (enhanced command-line completion)
vim.opt.wildmenu = true
vim.opt.wildmode:append({'longest:full', 'full'})

-- Virtual edit (enable visual block to select over eol)
vim.opt.virtualedit:append({'block'})

-- Format options
vim.api.nvim_create_autocmd('bufenter', {
  group = 'init',
  pattern = {'*'},
  callback = function()
    vim.opt_local.formatoptions:remove('or')
    vim.opt_local.formatoptions:append('Mj')
  end,
})
vim.opt.nrformats:remove({'octal'})
vim.opt.joinspaces = false

-- End of line action
vim.opt.textwidth = 0  -- disable text wrap
vim.opt.backspace = {'indent', 'eol', 'start'}

-- Ignore unnecessary files from completion
vim.opt.wildignore = {
  '*.sw?',  -- vim swap file
  '*.bak', '*.?~', '*.??~', '*.???~', '*.~',  -- backup files
  '*.pyc',  -- python byte code
}

-- Help setting
vim.opt.keywordprg = ':help'
vim.opt.helplang = {'ja', 'en'}

-- Improve timeout
vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 50

-- Command-line completion behaviour
vim.opt.completeopt:append({'menu', 'menuone', 'noselect', 'noinsert'})

-- Visual bell
vim.opt.visualbell = true
vim.opt.errorbells = false

-- Mouse
vim.opt.mouse = 'a'
vim.opt.mousehide = true
vim.opt.mousemodel = 'popup'

-- Display setting
vim.opt.scrolloff = 5  -- min lines of up/bottom of cursor
vim.opt.sidescrolloff = 5  -- min cols of left/right of cursor
vim.opt.wrap = true  -- wrap long line (only on display)
vim.opt.number = false  -- disble number sign col
vim.opt.showcmd = true  -- show show some command in the end of cmd win
vim.opt.report = 2  -- threashold for reporting number of lines changed
vim.opt.ruler = false

-- Spell check
vim.opt.spell = false  -- disable spell check by default
vim.opt.spelllang:append({'cjk'})  -- disable spell check on multibyte characters
vim.opt.spelloptions:append({'camel'})  -- Enable spell check for camel case words

-- Invisible chars
vim.opt.list = true  -- display invisible chars
vim.opt.listchars = {tab = '| ', trail = '_'}
vim.opt.fillchars:append({vert = '┃'})
vim.opt.linebreak = false
vim.opt.shiftround = true -- round indent to multile of 'shiftwidth'
vim.opt.showbreak = '↪ '
vim.opt.breakindent = true
vim.opt.ambiwidth = 'single'

-- Window setting
vim.opt.cmdheight = 1
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.equalalways = false  -- disable to set all windows to the same size aster split/close

-- Folding setting
vim.opt.foldmethod = 'marker'

-- Search setting
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.history = 10000
vim.opt.wrapscan = false

-- Tab/indent setting (global)
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.cindent = false
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Rendering setting
-- vim.opt.synmaxcol = 360
vim.opt.lazyredraw = true

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

-- load plugin config
require('plugins')

-- end startup time profiling
vim.cmd([[
  if has('vim_starting') && has('reltime')
    autocmd VimEnter * echomsg 'startuptime: ' . reltimestr(reltime(g:startuptime))
  endif
]])

-- vim: set sw=2 et

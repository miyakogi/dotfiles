-- =========================================================
-- Startup
-- =========================================================

-- Create default auto group
vim.api.nvim_create_augroup('init', {})


-- =========================================================
-- Set Global Options
-- =========================================================

-- Disable default plugins
vim.g.loaded_gzip = 1
vim.g.loaded_LogiPat = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zipPlugin = 1

-- from: https://zenn.dev/kawarimidoll/articles/8172a4c29a6653
vim.g.did_install_default_menus = 1
vim.g.loaded_2html_plugin       = 1
vim.g.loaded_man                = 1
vim.g.loaded_matchit            = 1
vim.g.loaded_matchparen         = 1
vim.g.loaded_remote_plugins     = 1
vim.g.loaded_shada_plugin       = 1
vim.g.loaded_spellfile_plugin   = 1
vim.g.loaded_tutor_mode_plugin  = 1
vim.g.skip_loading_mswin        = 1

-- =========================================================
-- Set Global Options
-- =========================================================

-- Reload when file modified outside nvim
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
vim.opt.mousemodel = 'popup'

-- Display setting
vim.opt.scrolloff = 5  -- min lines of up/bottom of cursor
vim.opt.sidescrolloff = 5  -- min cols of left/right of cursor
vim.opt.wrap = true  -- wrap long line (only on display)
vim.opt.number = false  -- disable number sign col
vim.opt.showcmd = true  -- show some command in the end of cmd win
vim.opt.report = 2  -- threshold for reporting number of lines changed
vim.opt.ruler = false

-- Spell check
vim.opt.spell = true  -- enable spell check and spellsitter by default
vim.opt.spelllang:append({'cjk'})  -- disable spell check on multibyte characters
vim.opt.spelloptions:append({'camel'})  -- Enable spell check for camel case words

-- Invisible chars
vim.opt.list = true  -- display invisible chars
vim.opt.listchars = {tab = '| ', trail = '_'}
vim.opt.fillchars:append({vert = '┃'})
vim.opt.linebreak = false
vim.opt.shiftround = true -- round indent to multiple of 'shiftwidth'
vim.opt.showbreak = '󱞩 '
vim.opt.breakindent = true
vim.opt.ambiwidth = 'single'

-- Window setting
vim.opt.cmdheight = 1  -- always show status-line, command-line is shown by noice.nvim
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
vim.opt.lazyredraw = false

-- Color setting
vim.opt.termguicolors = true

-- =========================================================
-- Key Mapping
-- =========================================================

vim.g.mapleader = ","

-- ======== Normal/Visual Cursor Move ========
-- Swap colon/semicolon
-- vim.keymap.set('n', ';', ':')
-- vim.keymap.set('n', ':', ';')

-- Wrap start/end of lines by cursor keys
vim.api.nvim_set_option('whichwrap', 'b,s,<,>,[,]')
-- Wrap start/end of lines by h and l keys
vim.keymap.set('n', 'h', '<Left>')
vim.keymap.set('n', 'l', '<Right>')
vim.keymap.set('x', 'h', '<Left>')
vim.keymap.set('x', 'l', '<Right>')

-- Move up/down with display lines
vim.keymap.set({'n', 'x'}, 'j', 'gj', { silent = true })
vim.keymap.set({'n', 'x'}, 'k', 'gk', { silent = true })
vim.keymap.set({'n', 'x'}, 'gj', 'j', { silent = true })
vim.keymap.set({'n', 'x'}, 'gk', 'k', { silent = true })
vim.keymap.set({'n', 'x'}, '<Down>', 'g<Down>', { silent = true })
vim.keymap.set({'n', 'x'}, '<Up>', 'g<Up>', { silent = true })
vim.keymap.set({'n', 'x'}, 'g<Down>', '<Down>', { silent = true })
vim.keymap.set({'n', 'x'}, 'g<Up>', '<Up>', { silent = true })

-- Move to start/end of lines
vim.keymap.set({'n', 'x'}, 'gh', '^', { silent = true })  -- from helix-editor
vim.keymap.set({'n', 'x'}, 'gs', '0', { silent = true })  -- from helix-editor
vim.keymap.set({'n', 'x'}, 'gl', '$', { silent = true })  -- from helix-editor

-- Go to file end
vim.keymap.set({'n', 'x'}, 'ge', 'G', { silent = true }) -- from helix-editor

-- Redo
vim.keymap.set('n', 'U', '<C-r>')  -- from helix-editor

-- ======== Insert/Command Cursor Move ========
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
vim.api.nvim_set_option('showtabline', 1)
vim.keymap.set('n', '<C-j>', 'gt')
vim.keymap.set('n', '<C-k>', 'gT')

-- ======== Misc ========
-- Disable dangerous/unnecessary keys
vim.keymap.set('n', 'ZZ', '<Nop>')  -- danger
vim.keymap.set('n', 'ZQ', '<Nop>')  -- danger
vim.keymap.set('n', '<F1>', '<Nop>')  -- show help

-- Cut right of cursor
vim.keymap.set('i', '<C-k>', '<C-g>u<C-\\><C-o>D')
vim.keymap.set('c', '<C-k>', '<C-g>u<C-\\><C-o>D')

-- Copy/Paset/Cut from/to clipboard
vim.keymap.set('i', '<C-v>', '<C-o>:set paste<CR><C-r>+<C-o>:set nopaste<CR>', { silent = true })
vim.keymap.set('i', '<A-v>', '<C-v>')
vim.keymap.set('i', '<C-z>', '<C-v>')
vim.keymap.set('c', '<C-v>', '<C-r>+')
vim.keymap.set('c', '<A-v>', '<C-v>')
vim.keymap.set('c', '<C-z>', '<C-v>')
vim.keymap.set('x', '<C-c>', '"+y')
vim.keymap.set('x', '<C-x>', '"+d')
vim.keymap.set('x', '<C-v>', '"+p')

vim .keymap.set('x', '<Space>y', '"+y')  -- from helix-editor
vim .keymap.set('n', '<Space>p', '"+p')  -- from helix-editor
vim .keymap.set('n', '<Space>P', '"+P')  -- from helix-editor

-- Use C-q to do what C-v used to do
vim.keymap.set('n', '<C-q>', '<C-v>')

-- ======== Keyd Fixup ========
vim.keymap.set('i', '<C-backspace>', '<C-w>')

-- ======== Command Mapping ========

-- Clear highlighting search word
vim.keymap.set('n', '<Esc><Esc>', ':<C-u>nohl<CR><C-l>')
vim.keymap.set('n', '<C-l>', ':<C-u>nohl<CR><C-l>')

-- ======== Autocmd =======
-- Fix: back to original cursor shape on some terminal
local term = vim.env.TERM
if term == "foot" or term == "alacritty" or term == "wezterm" then
  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function ()
      vim.opt.guicursor = ""
      vim.fn.chansend(vim.v.stderr, "\x1b[ q")
    end
  })
end

-- =========================================================
-- Plugin
-- =========================================================

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load plugin config
require('lazy-config')  -- all package settings with lazy.nvim
require('autolcd')  -- automatically change local working directory for buffers
require('quick-closer')  -- quickly close tiny buffers by pressing `q` in normal mode

-- vim: set sw=2 et

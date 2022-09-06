-- Nvim Quick Closer Plugin
-- Quickly close *tiny* buffer by pressing `q` on normal mode

-- Define filetypes
local filetypes = {
  'help',
  'qf',  -- quickfix window
}

-- Define keymap
local function set_keymap()
  vim.keymap.set(
    'n',
    'q',
    function()
      vim.api.nvim_command('close')
    end,
    { buffer = true }
  )
end

-- Define autocmd
vim.api.nvim_create_augroup('quick-closer', {})
vim.api.nvim_create_autocmd(
  'filetype',
  {
    group = 'quick-closer',
    pattern = filetypes,
    callback = set_keymap,
  }
)

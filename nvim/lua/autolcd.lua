-- Automatically Change Local Working Directory for Buffers
-- This script requires [`plenary.nvim`](https://github.com/nvim-lua/plenary.nvim)

local function autolcd()
  local current_dir = require('plenary.path'):new({ vim.fn.expand('%:p:h') })
  if current_dir:is_dir() then
    vim.api.nvim_command('lcd ' .. tostring(current_dir))
  end
end

vim.api.nvim_create_augroup('autolcd', {})
vim.api.nvim_create_autocmd(
  'bufenter',
  {
    group = 'autolcd',
    callback = autolcd,
  }
)

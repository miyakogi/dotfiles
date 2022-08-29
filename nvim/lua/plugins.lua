-- Package Configuration File

return require('packer').startup(function(use)
  -- manage packer.nvim itself
  use 'wbthomason/packer.nvim'

  -- input method (fcitx/fcitx5 control)
  use 'h-hg/fcitx.nvim'

end)

-- vim: set sw=2 et

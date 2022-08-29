-- Package Configuration File

return require('packer').startup(function(use)
  -- manage packer.nvim itself
  use 'wbthomason/packer.nvim'

  -- tree-sitter support
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        -- A list of parser names, or 'all'
        ensure_installed = {
          'bash',
          'c',
          'cpp',
          -- 'dart',
          'dockerfile',
          'fish',
          'gitignore',
          'help',
          'html',
          'javascript',
          'json',
          'jsonc',
          'lua',
          'make',
          'markdown',
          'markdown_inline',
          'python',
          'rst',
          'rust',
          'toml',
          'typescript',
          'vue',
          'yaml',
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- List of parsers to ignore installing (for "all")
        ignore_install = { },

        highlight = {
          -- `false` will disable the whole extension
          enable = true,

          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          disable = { },

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  }

  -- surround (parenthesis/quote/tab/etc...) control
  -- replacement of 'tpope/vim-surround'
  use {
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup()
    end,
  }

  -- auto surrounding/pairing
  -- replacement of 'Raimondi/delimitMate'
  use {
    'windwp/nvim-autopairs',
    opt = true,
    event = 'InsertEnter',
    config = function()
      require'nvim-autopairs'.setup({
        map_c_h = true,
      })
    end,
  }

  -- comment plugin
  -- replacement of 'tomtom/tcomment_vim'
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  }

  -- input method (fcitx/fcitx5) control
  use {
    'h-hg/fcitx.nvim',
    opt = true,
    event = 'InsertEnter',
  }

end)

-- vim: set sw=2 et

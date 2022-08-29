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

  -- file management

  -- telescope.nvim - find, filter, preview, and pick files
  -- replacement of denite.nvim
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    run = ':checkhealth telescope',
    config = function()
      vim.keymap.set('n', '<Leader>ff', function() require('telescope.builtin').find_files() end)
      -- TODO: more customization
    end
  }

  -- external terminal based file-manager integration
  use {
    'is0n/fm-nvim',
    config = function()
      require('fm-nvim').setup({})
    end,
  }

  -- git integration
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        on_attach = function(bufnr)
          -- navigation key mappings
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          map('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true })
        end,
      })

      -- add command
      vim.api.nvim_create_user_command(
        'Gwrite',  -- stage file
        'Gitsigns stage_buffer',
        {}
      )
      vim.api.nvim_create_user_command(
        'Gdiff',  -- show diff
        'Gitsigns diffthis',
        {}
      )
    end,
  }

  -- spellchecker
  use {
    'lewis6991/spellsitter.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('spellsitter').setup({})
    end,
  }

  -- highlight current word
  -- replacement of 'itchyny/vim-cursorword'
  use {
    'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure({
        delay = 30,  -- sway's key repeat rate = 36 -> 27.8ms
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
      require('Comment').setup({})
    end,
  }

  -- status line
  -- replacement of 'itchyny/lightline.vim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      {
        'kyazdani42/nvim-web-devicons',
        opt = true,
      }, {
        'RRethy/nvim-base16',
        config = function()
          vim.cmd([[ colorscheme base16-tomorrow-night-eighties ]])
        end,
      },
    },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'base16',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
      })
    end,
  }

  -- indent highlight
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup({
        char = '▏',
        char_blankline = ' ',
        show_current_context = true,
        show_current_context_start = false,
      })
    end,
  }

  -- rainbow-parenthesis
  use {
    'p00f/nvim-ts-rainbow',
    requires = { { 'nvim-treesitter/nvim-treesitter', }, },
    config = function()
      require('nvim-treesitter.configs').setup({
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
      })
    end
  }

  -- abbreviation
  use {
    'tpope/vim-abolish',
    opt = true,
    event = 'InsertEnter',
    config = function()
      vim.cmd([[
        :Abolish teh the
        :Abolish qunatum quantum
        :Abolish fro for
        :Abolish sefl self
        :Abolish strign string
        :Abolish tokne{,s} token{}
      ]])
    end
  }

  -- open the last-edited place
  use {
    'ethanholz/nvim-lastplace',
    config = function()
      require('nvim-lastplace').setup({})
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

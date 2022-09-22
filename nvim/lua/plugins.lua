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
          additional_vim_regex_highlighting = {
            -- need for zk-nvim
            'markdown',
          },
        },
      })
    end,
  }

  -- file management

  -- telescope.nvim - find, filter, preview, and pick files
  -- replacement of denite.nvim
  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
    run = ':checkhealth telescope',
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')

      telescope.setup({
        defaults = {
          path_dispaly = { truncate = 4 },
          mappings = {
            i = {
              ['<esc>'] = actions.close,  -- <Esc> close popup
              ['<C-u>'] = false,  -- <C-u> clear prompt
            },
          },
        },
        pickers = {
          find_files = {
            -- theme = 'dropdown',
          },
        },
        extensions = {
          fzf = {
            fuzzy = false,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
        },
      })

      -- load fzf extension
      telescope.load_extension('fzf')

      -- set key mappings
      vim.keymap.set('n', '<Leader>ff', function() require('telescope.builtin').find_files() end)
      vim.keymap.set('n', '<Leader>fg', function() require('telescope.builtin').git_files() end)
      vim.keymap.set('n', '<Leader>fm', function() require('telescope.builtin').oldfiles() end)
    end
  }

  -- external terminal based file-manager integration
  use {
    'is0n/fm-nvim',
    config = function()
      require('fm-nvim').setup({})
      if vim.fn.executable('lf') then
        vim.keymap.set('n', '<Space>e', ':Lf<CR>')
      end
      if vim.fn.executable('gitui') then
        vim.keymap.set('n', '<Space>g', ':Gitui<CR>')
      end
    end,
  }

  -- note taking
  use {
    'mickael-menu/zk-nvim',
    requires = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('zk').setup({
        picker = 'telescope',
        lsp = {
          config = {
            cmd = { 'zk', 'lsp' },
            name = 'zk',
          },
          auto_attach = {
            enabled = true,
            filetypes = { 'markdown', },
          },
        },
      })

      -- key mapping
      local opts = { noremap = true, silent = false, }
      -- create a new note with title
      vim.keymap.set('n', '<Leader>zn', '<Cmd>ZkNew { title = vim.fn.input("title: ") }<CR>', opts)
      -- open note
      vim.keymap.set('n', '<Leader>zo', '<Cmd>ZkNotes { sort = { "modified" } }<CR>', opts)
      -- open note by tag
      vim.keymap.set('n', '<Leader>zt', '<Cmd>ZkTags<CR>', opts)
      -- search note by search query
      vim.keymap.set('n', '<Leader>zf', '<Cmd>ZkNotes { sort = { "modified" }, match = vim.fn.input("Search: ") }<CR>', opts)
      -- search selected word
      vim.keymap.set('v', '<Leader>zf', ':ZkMatch<CR>', opts)
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

  -- lsp
  use {
    'neovim/nvim-lspconfig',
    config = function()
      -- Start LSP Client When Opening Supported Files
      vim.api.nvim_create_augroup('lsp', {})
      local function lsp_autocmd(pattern)
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNew' }, {
          group = 'lsp',
          callback = function() vim.api.nvim_command('LspStart') end,
          pattern = pattern,
        })
      end

      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']e', vim.diagnostic.goto_next, opts)

      local on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- key mapping
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)

        -- command
        vim.api.nvim_create_user_command('Rename', function() vim.lsp.buf.references(bufopts) end, {})
      end

      local lsp_flags = {
        document_text_change = 150,
      }

      -- bash
      -- requires `shellcheck` command to enable diagnostic
      if vim.fn.executable('bash-language-server') > 0 then
        lsp_autocmd({ '*.bash', '*.sh' })
        require('lspconfig')['bashls'].setup({
          on_attach = on_attach,
          flags = lsp_flags,
          filetypes = { 'sh', 'bash' },
        })
      end

      -- lua
      if vim.fn.executable('lua-language-server') > 0 then
        lsp_autocmd({ '*.lua' })
        require('lspconfig')['sumneko_lua'].setup({
          on_attach = on_attach,
          flags = lsp_flags,
          settings = {
            Lua = {
              runtime = {
                -- neovim embedded lua is LuaJIT
                version = 'LuaJIT',
              },
              diagnostics = {
                enable = true,
                -- ignore undefined error for `vim` global variable on nvim config
                globals = { 'vim' },
              },
              workspaces = {
                -- make the server aware of neovim runtime files
                library = vim.api.nvim_get_runtime_file('', true),
              },
              -- Do not send telemetry data
              telemetry = {
                enable = false,
              },
            },
          },
        })
      end

      -- python
      if vim.fn.executable('pyright-langserver') > 0 then
        lsp_autocmd({ '*.py' })
        require('lspconfig')['pyright'].setup({
          on_attach = on_attach,
          flags = lsp_flags,
        })
      end

      -- rust
      if vim.fn.executable('rust-analyzer') > 0 then
        lsp_autocmd({ '*.rs' })
        require('lspconfig')['rust_analyzer'].setup({
          on_attach = on_attach,
          flags = lsp_flags,
          settings = {
            -- server specific setting
            ["rust-analyzer"] = {}
          }
        })
      end
    end,
  }

  -- show icon on lsp types
  use {
    'onsails/lspkind.nvim',
    opt = true,
    event = 'InsertEnter',
    requires = { 'hrsh7th/nvim-cmp' },
    config = function()
      local lspkind = require('lspkind')
      require('cmp').setup {
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text', -- show symbol and text
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function (_, vim_item)
              return vim_item
            end
          })
        }
      }
    end,
  }

  -- completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
        { 'f3fora/cmp-spell' },
        { 'saadparwaiz1/cmp_luasnip' },
      },
      setup = function()
        vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
      end,
      config = function()
        -- setup nvim-cmp
        local cmp = require('cmp')
        cmp.setup({
          -- snippet
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body)
            end
          },

          -- mapping
          mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-Space>'] = cmp.mapping.complete(),
          }),

          -- sources
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
          }, {
            { name = 'buffer' },
            { name = 'spell' },
          }),
        })
    end,
  }

  -- snippet
  use {
    'L3MON4D3/LuaSnip',
    requires = { 'rafamadriz/friendly-snippets' },
    opt = false,  -- lazy loading breaks nvim-cmp's snippet sources
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      -- failed to set <C-Space> for expand/jump
      vim.cmd([[
        imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
        imap <silent><expr> <C-j> '<Plug>luasnip-expand-or-jump'
      ]])
    end,
  }

  -- smartchr
  use {
    'kana/vim-smartchr',
    opt = true,
    event = 'InsertEnter',
    setup = function()  -- Define autocmd at setup, as `config` is called after entering insert-mode
      -- filetype specific keymappings
      vim.api.nvim_create_augroup('smartchr', {})

      -- python
      vim.api.nvim_create_autocmd(
        'bufenter',
        {
          group = 'smartchr',
          pattern = '*.py',
          callback = function()
            vim.cmd([[
              inoremap <expr> <buffer> = smartchr#loop(' = ', '=', ' == ', '==')
            ]])
          end,
        }
      )

      -- rust
      vim.api.nvim_create_autocmd(
        'bufenter',
        {
          group = 'smartchr',
          pattern = '*.rs',
          callback = function()
            vim.cmd([[
              inoremap <expr> <buffer> <C-l> smartchr#loop(' -> ', ' => ')
              inoremap <expr> <buffer> = smartchr#loop(' = ', '=', ' == ', '==')
            ]])
          end,
        }
      )

      -- javascript
      vim.api.nvim_create_autocmd(
        'bufenter',
        {
          group = 'smartchr',
          pattern = '*.js',
          callback = function()
            vim.cmd([[
              inoremap <expr> <buffer> = smartchr#loop(' = ', '=', ' == ', ' === ')
            ]])
          end,
        }
      )
    end,
    config = function()
      -- gloabally set `,`
      --vim.keymap.set('i', ',', function() vim.fn['smartchr#loop'](', ', ',') end, { expr = true, noremap = true })
      -- `vim.keymap.set` does not work...
      vim.cmd([[
        inoremap <expr> , smartchr#loop(', ', ',')
      ]])
    end,
  }

  -- textobj
  -- wiw (support `snake_case`, `CamelCase`, `CAPITAL_CASE`, and so on...)
  use {
    'rhysd/vim-textobj-wiw',
    requires = { 'kana/vim-textobj-user', },
    setup = function()
      vim.g.textobj_wiw_no_default_key_mappings = 1
    end,
    config = function()
      vim.keymap.set({'x', 'o'}, 'au', '<Plug>(textobj-wiw-a)', { noremap = false })
      vim.keymap.set({'x', 'o'}, 'iu', '<Plug>(textobj-wiw-i)', { noremap = false })
    end,
  }
  -- parameter (support function parameters)
  use {
    'sgur/vim-textobj-parameter',
    requires = { 'kana/vim-textobj-user', },
  }

  -- spellchecker
  use {
    'lewis6991/spellsitter.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('spellsitter').setup({})
    end,
  }

  -- visual star (search by selected region)
  use {
    'thinca/vim-visualstar',
    setup = function()
      vim.g.visualstar_no_default_key_mappings = 1
    end,
    config = function()
      vim.keymap.set('x', '*', '<Plug>(visualstar-*)')
      vim.keymap.set('x', 'g*', '<Plug>(visualstar-g*)')
      vim.keymap.set('x', '#', '<Plug>(visualstar-#)')
      vim.keymap.set('x', 'g#', '<Plug>(visualstar-g#)')
    end
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
          vim.cmd([[ colorscheme base16-eighties ]])
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
  -- replacement of indentLine
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
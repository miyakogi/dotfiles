-- ####### Lazy.nvim ######

local plugins = {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      { 'mrjones2014/nvim-ts-rainbow' },
    },
    build = ':TSUpdate',
    config = function ()
      require('nvim-treesitter.configs').setup({
        -- A list of parser names, or 'all'
        ensure_installed = {
          'bash',
          'c',
          'cpp',
          'dart',
          'dockerfile',
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
          'regex',
          'rst',
          'rust',
          'toml',
          'typescript',
          'vue',
          'yaml',
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers whne entering buffer
        auto_install = true,

        -- List of parsers to ignore installing (for "all")
        ignore_install = {},

        highlight = {
          -- `false` will disable the whole extension
          enable = true,

          disable = {},

          additional_vim_regex_highlighting = {
            'markdown',  -- required for zk-nvim
          },
        },

        -- rainbow-parenthesis
        rainbow = {
          enable = true,
          extended_mode = true,
          mx_file_lines = nil,
        },
      })
    end,
  },

  {
    'nvim-treesitter/playground',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter' },
    },
    lazy = true,
    cmd = {
      'TSHighlightCapturesUnderCursor',
    },
  },

  -- ### File Management ###
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    build = ':checkhealth telescope',
    lazy = true,
    keys = {
      { '<Leader>ff', function() require('telescope.builtin').find_files() end, },
      { '<Leader>fg', function() require('telescope.builtin').git_files() end, },
      { '<Leader>fm', function() require('telescope.builtin').oldfiles() end, },
      { '<Space>f', function() require('telescope.builtin').find_files() end, },
    },
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
          layout_strategy = 'flex',
          layout_config = {
            flex = {
              flip_columns = 120,
              flip_lines = 40,
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
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },  -- optional, for file icons
    },
    tag = 'nightly',  -- optional, updated every week. (see issue #1193)
    lazy  = true,
    keys = {
      {
        '<Space>e',
        function()
          if vim.fn.bufname('%'):find('^NvimTree_') then
            vim.api.nvim_command('NvimTreeClose')
          else
            vim.api.nvim_command('NvimTreeFocus')
          end
        end,
      },
    },
    config = function()
      -- set options
      require('nvim-tree').setup({
        disable_netrw = true,
        sort_by = 'case_sensitive',
        git = {
          ignore = false,  -- show gitignored files by default - toggle by <S-I>
        },
        view = {
          signcolumn = 'yes',
        },
        filters = {
          dotfiles = true,  -- hide dotfiles by default - toggle by <S-H>
        },
      })
    end
  },

  -- external terminal based file-manager integration
  {
    'is0n/fm-nvim',
    lazy = true,
    keys = {
      { '<Space>g', '<cmd>Gitui<cr>' },
    },
    cmd = {
      'Lf',
      'Joshuto',
      'Ranger',
    },
    config = function()
      require('fm-nvim').setup({})
    end,
  },

  {
    'ggandor/leap.nvim',
    dependencies = {
      { 'tpope/vim-repeat' },
    },
    lazy = true,
    keys = {
      { 'f', '<Plug>(leap-forward-to)', mode = {'n', 'x', 'o'}, },
      { 'F', '<Plug>(leap-backward-to)', mode = {'n', 'x', 'o'}, },
    },
    config = function()
      require('leap').add_default_mappings()
    end,
  },

  -- note taking
  {
    'mickael-menu/zk-nvim',
    dependencies = {
      { 'nvim-telescope/telescope.nvim' },
    },
    lazy = true,
    keys = {
      -- create a new note with title
      { '<Leader>zn', '<Cmd>ZkNew { title = vim.fn.input("title: ") }<CR>' },
      -- open note
      { '<Leader>zo', '<Cmd>ZkNotes { sort = { "modified" } }<CR>' },
      -- open note by tag
      { '<Leader>zt', '<Cmd>ZkTags<CR>' },
      -- search note by search query
      { '<Leader>zf', '<Cmd>ZkNotes { sort = { "modified" }, match = vim.fn.input("Search: ") }<CR>' },
      -- search selected word
      { '<Leader>zf', ':ZkMatch<CR>', mode = 'x' }
    },
    cmd = {
      'ZkNew',
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
    end,
  },

  -- todo list support for markdown
  {
    'miyakogi/todolist.vim',
  },

  -- git integration
  {
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
  },

  -- lsp
  {
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

      -- c/cpp
      -- requires `clangd` included in `clang` package
      if vim.fn.executable('clangd') > 0 then
        lsp_autocmd({ '*.c', '*.h', '*.cpp', '*.hpp' })
        require('lspconfig')['clangd'].setup({
          on_attach = on_attach,
          flags = lsp_flags,
        })
      end

      -- lua
      if vim.fn.executable('lua-language-server') > 0 then
        lsp_autocmd({ '*.lua' })
        require('lspconfig')['lua_ls'].setup({
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

      -- zk
      if vim.fn.executable('zk') > 0 then
        require('lspconfig').zk = {
          default_config = {
            cmd = {'zk', 'lsp'},
            filetypes = { 'markdown' },
            root_dir = function()
              return vim.loop.cwd()
            end,
            settings = {},
          }
        }
      end
    end,
  },

  -- show icon on lsp types
  {
    'onsails/lspkind.nvim',
    lazy = true,
    event = 'InsertEnter',
    dependencies = {
      { 'hrsh7th/nvim-cmp' },
    },
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
  },

  -- completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      { 'f3fora/cmp-spell' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'L3MON4D3/LuaSnip' },
    },
    lazy = true,
    event = 'InsertEnter',
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
          ['<C-x>'] = cmp.mapping.complete(),
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
  },

  -- snippet
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      { 'honza/vim-snippets' },
    },
    lazy = true,
    config = function()
      require("luasnip.loaders.from_snipmate").lazy_load()
      -- failed to set <C-Space> for expand/jump
      vim.cmd([[
        imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
        imap <silent><expr> <C-Space> '<Plug>luasnip-expand-or-jump'
      ]])
    end,
  },

  -- smartchr
  {
    'kana/vim-smartchr',
    lazy = true,
    event = 'InsertEnter',
    init = function()  -- Define autocmd at setup, as `config` is called after entering insert-mode
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
  },

  -- textobj
  -- wiw (support `snake_case`, `CamelCase`, `CAPITAL_CASE`, and so on...)
  {
    'rhysd/vim-textobj-wiw',
    dependencies = {
      { 'kana/vim-textobj-user' },
    },
    init = function()
      vim.g.textobj_wiw_no_default_key_mappings = 1
    end,
    config = function()
      vim.keymap.set({'x', 'o'}, 'au', '<Plug>(textobj-wiw-a)', { noremap = false })
      vim.keymap.set({'x', 'o'}, 'iu', '<Plug>(textobj-wiw-i)', { noremap = false })
    end,
  },

  -- parameter (support function parameters)
  {
    'sgur/vim-textobj-parameter',
    dependencies = {
      { 'kana/vim-textobj-user' },
    },
  },

  -- spellchecker
  {
    'lewis6991/spellsitter.nvim',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter' },
    },
    config = function()
      require('spellsitter').setup({})
    end,
  },

  -- highlight current word
  {
    'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure({
        delay = 30,  -- sway's key repeat rate = 36/s -> 27.8ms
      })
    end,
  },


  -- notification
  {
    'folke/noice.nvim',
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('noice').setup({})
    end,
  },

  -- surround (parenthesis/quote/tab/etc...) control
  {
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup()
    end,
  },

  -- auto surrounding/pairing
  {
    'windwp/nvim-autopairs',
    lazy = true,
    event = 'InsertEnter',
    config = function()
      require'nvim-autopairs'.setup({
        map_cr = true,
        map_c_h = true,
      })

      -- disable autopair for `[[]]`
      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')
      npairs.add_rule(Rule('[[', '', 'markdown'))
    end,
  },

  -- comment plugin
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({})
    end,
  },

  -- status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
      }, {
        'EdenEast/nightfox.nvim',
      },
    },
    config = function()
      require('lualine').setup({
        options = {
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
      })
    end,
  },

  -- markdown preview
  {
    'toppair/peek.nvim',
    build = 'deno task --quiet build:fast',
    lazy = true,
    cmd = 'PeekOpen',
    -- filetype = 'markdown',
    config = function ()
      require('peek').setup({
        auto_load = true,
        close_on_bdelete = true,
        syntax = true,
        theme = 'dark',
        update_on_change = true,

        -- relevant if update_on_change is true
        throttle_at = 200000,     -- start throttling when file exceeds this
                                  -- amount of bytes in size
        throttle_time = 'auto',   -- minimum amount of time in milliseconds
                                  -- that has to pass before starting new render
      })

      -- add command
      vim.api.nvim_create_user_command('PeekOpen', function()
        require('peek').open()
      end, {})
      vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
    end
  },

  -- ### ColorScheme ###
  {
    'EdenEast/nightfox.nvim',
    config = function()
      local groups = {
        all = {
          NvimTreeWinSeparator = { fg = 'palette.bg0', bg = 'palette.bg0', },
        },
      }

      require('nightfox').setup({
        options = {
          styles = {
            comments = 'italic',
          },
          modules = {
            illuminate = false,
          },
        },
        groups = groups,
      })

      vim.cmd.colorscheme('nordfox')
    end
  },


  -- indent highlight
  {
    'lukas-reineke/indent-blankline.nvim',
    dependencies = {
      { 'EdenEast/nightfox.nvim' },
    },
    config = function()
      require('indent_blankline').setup({
        char = '▏',
        char_blankline = '',
        show_current_context = true,
        show_current_context_start = false,
      })
    end,
  },

  -- abbreviation
  {
    'tpope/vim-abolish',
    lazy = true,
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
  },

  -- open the last-edited place
  {
    'ethanholz/nvim-lastplace',
    config = function()
      require('nvim-lastplace').setup({})
    end,
  },

  -- input method (fcitx/fcitx5) control
  {
    'h-hg/fcitx.nvim',
    lazy = true,
    event = 'InsertEnter',
  },
}

require('lazy').setup(plugins)

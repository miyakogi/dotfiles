-- ####### Lazy.nvim ######

local plugins = {
  {
    -- Need as a library
    'nvim-lua/plenary.nvim',
    lazy = true,
  },

  {
    'nvim-treesitter/nvim-treesitter',
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
          'html',
          -- 'javascript',
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
          'vim',
          'vimdoc',
          'vue',
          'yaml',
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- List of parsers to ignore installing (for "all")
        ignore_install = {
          'javascript',
        },

        highlight = {
          -- `false` will disable the whole extension
          enable = true,

          disable = {},

          additional_vim_regex_highlighting = {
            'markdown',  -- required for zk-nvim
          },
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

  -- git integration
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
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
      local opts = { noremap = true, silent = true }
      local goto_error_prev = function()
        vim.diagnostic.jump({
          count = -1,
          wrap = false,
        })
      end
      local goto_error_next = function()
        vim.diagnostic.jump({
          count = 1,
          wrap = false,
        })
      end
      vim.keymap.set('n', '[e', goto_error_prev, opts)
      vim.keymap.set('n', ']e', goto_error_next, opts)

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

      -- spell check
      if vim.fn.executable('typos-lsp') > 0 then
        vim.lsp.enable('typos_lsp')
        vim.lsp.config('typos_lsp', {
          on_attach = on_attach,
          flags = lsp_flags,
        })
      end

      -- bash
      -- requires `shellcheck` command to enable diagnostic
      if vim.fn.executable('bash-language-server') > 0 then
        vim.lsp.enable('bashls')
        vim.lsp.config('bashls', {
          on_attach = on_attach,
          flags = lsp_flags,
          filetypes = { 'sh', 'bash' },
        })
      end

      -- fsh
      -- requires `fish-lsp` command
      if vim.fn.executable('fish-lsp') > 0 then
        vim.lsp.enable('fish-lsp')
        vim.lsp.config('fish-lsp', {
          on_attach = on_attach,
          flags = lsp_flags,
          cmd = { 'fish-lsp', 'start' },
          filetypes = { 'fish' },
        })
      end

      -- c/cpp
      -- requires `clangd` included in `clang` package
      if vim.fn.executable('clangd') > 0 then
        vim.lsp.enable('clangd')
        vim.lsp.config('clangd', {
          on_attach = on_attach,
          flags = lsp_flags,
        })
      end

      -- elixir
      if vim.fn.executable('elixir-ls') > 0 then
        vim.lsp.enable('elixirls')
        vim.lsp.config('elixirls', {
          cmd = {'elixir-ls'}
        })
      end

      -- lua
      if vim.fn.executable('lua-language-server') > 0 then
        vim.lsp.enable('lua_ls')
        vim.lsp.config('lua_ls', {
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
      if vim.fn.executable('pyright') > 0 then
        vim.lsp.enable('pyright')
        vim.lsp.config('pyright', {
          on_attach = on_attach,
          flags = lsp_flags,
        })
      end

      -- rust
      if vim.fn.executable('rust-analyzer') > 0 then
        vim.lsp.enable('rust_analyzer')
        vim.lsp.config('rust_analyzer', {
          on_attach = on_attach,
          flags = lsp_flags,
          settings = {
            -- server specific setting
            ['rust-analyzer'] = {}
          }
        })
      end

      -- zk
      if vim.fn.executable('zk') > 0 then
        vim.lsp.enable('zk')
        vim.lsp.config('zk', {
          filetypes = { 'markdown' },
        })
      end
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
      { 'onsails/lspkind.nvim'},
    },
    lazy = true,
    event = 'InsertEnter',
    setup = function()
      vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
    end,
    config = function()
      -- setup nvim-cmp
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')

      cmp.setup({
        -- snippet
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },

        -- mapping
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-x>'] = cmp.mapping.complete(),
          ['<C-Space>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }
          ),
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

        -- lsp icon and text
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
        },
      })
    end,
  },

  {
    'michaelb/sniprun',
    branch = 'master',

    build = 'sh install.sh',
    -- do 'sh install.sh 1' if you want to force compile locally
    -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

    config = function()
      require('sniprun').setup({
      -- your options
      })
      vim.api.nvim_set_keymap('v', '<leader>r', '<Plug>SnipRun', {silent = true})
      vim.api.nvim_set_keymap('n', '<leader>c', '<Plug>SnipClose', {silent = true})
    end,
  },

  -- linter
  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        elixir = {
          'credo',
        },
        python = {
          'ruff',
        },
      }

      vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged', 'TextChangedI', 'BufRead', 'BufWrite' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },

  -- snippet
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      { 'miyakogi/vim-snippets' },
    },
    build = 'make install_jsregexp',
    lazy = true,
    config = function()
      require('luasnip.loaders.from_snipmate').lazy_load()
    end,
  },

  -- elixir
  {
    'elixir-editors/vim-elixir',
    ft = 'elixir',
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
      -- globally set `,`
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
    event = 'VeryLazy',
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('noice').setup({
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
      })

      require('notify').setup({
        background_colour = '#000000',
      })
    end,
  },

  {
    'folke/which-key.nvim',
    tag = 'stable',
    event = 'VeryLazy',
    opts = {
    },
    config = function()
      require('which-key').setup({
        preset = 'helix',
        delay = 10,
        triggers = {
          { '<auto>', mode = 'nixsotc' },
          { 's', mode = { 'n', 'v' } },  -- for mini.surround
        },
        plugins = {
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            window = true,
            nav = true,
            z = true,
            g = true,
          },
        },
      })
    end,
  },

  -- surround (parenthesis/quote/tab/etc...) control
  {
    'echasnovski/mini.surround',
    config = function()
      require('mini.surround').setup({})
    end,
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
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
    event = 'VeryLazy',
    dependencies = {
      {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
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

  -- ### ColorScheme ###
  {
    'rebelot/kanagawa.nvim',
    config = function()
      require('kanagawa').setup({
        compile = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,
        dimInactive = false,
        terminalColors = true,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = 'none',
              }
            }
          }
        }
      })
      vim.cmd([[colorscheme kanagawa-dragon]])
    end,
  },

  -- indent highlight
  -- -> moved into snacks.nvim

  -- abbreviation
  {
    'tpope/vim-abolish',
    lazy = true,
    event = 'InsertEnter',
    config = function()
      vim.cmd([[
        :Abolish teh the
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

  -- misc
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      dashboard = { enabled = true },
      -- explorer = { enabled = true },
      image = { enabled = true },
      indent = {
        enabled = true,
        animate = {
          duration = {
            steps = 25,
            total = 70,
          },
        },
      },
      picker = {
        enabled = true,
      },
      quickfile = { enabled = true },
      scroll = {
        enabled = true,
        animate = {
          duration = {
            steps = 25,
            total = 100,
          },
        },
        animate_repeat = {
          duration = {
            steps = 10,
            total = 50,
          },
        },
      },
      statuscolumn = { enabled = true },
    },
    keys = {
      -- picker
      { '<Leader>ff', function() Snacks.picker.files() end, desc = 'Find files' },
      { '<Leader>fg', function() Snacks.picker.git_files() end, desc = 'Find git files' },
      { '<Leader>fm', function() Snacks.picker.recent() end, desc = 'Recent files' },
      { '<Space>e', function() Snacks.picker.smart() end, desc = 'Smart find files' },
      { '<Space>f', function() Snacks.picker.smart() end, desc = 'Smart find files' },
    },
  },
}

-- note taking
if vim.fn.executable('zk') > 0 then
  plugins[#plugins+1] = {
    'mickael-menu/zk-nvim',
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
        picker = 'snacks_picker',
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
  }
end

if vim.fn.executable('deno') > 0 then
  -- markdown preview
  plugins[#plugins+1] = {
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
    end,
  }
end

require('lazy').setup(plugins)

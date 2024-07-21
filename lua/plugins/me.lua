local catcoffee = {
  "             ^~:                    :!!^                  ",
  "            :?!!7?7~^^^....:...:!77?!!7~                  ",
  "            ^?~!!!!!!!:    :!77!!!!!!!?:                  ",
  "            :!~!!!!~:        .^~!!!!!~?:                  ",
  "            !7!!~:.             .:^~!!7?                  ",
  "            7:.  .  .         . .    ..^:                 ",
  "           :.    ....    Y!    ..       ^.                ",
  "           ~  .:^^:      ::    .:^^:.    ~                ",
  "          :.    ..               ..      .:               ",
  "          ~                               ^.              ",
  "       ...~                                ! ..           ",
  "      !.  ^      .              ..         ^   ~          ",
  "      ~..:~:-.!777!!!^       .~!~!!7!:  .~ .^.:7 .....    ",
  "      :.     ...:!777?^ __. .7!!77~~~~:.      ::      .:  ",
  "       ^                        .             ~  ....   ^ ",
  "       :.                                    ^:      ^  :.",
  "        ~   ^  :~ :~ ^.:.. ..: :. :.~ :.::   ^     ^   ^  ",
  "        :. :.  ~^  ^ ^:..^ ~~ .^  ~.7:^^ ~  :.   .:   ^   ",
  "         ^  ^..!.! ^ :.  ^^:^  ^  ^..^!.^^  ~   :.  .^    ",
  "         ~                                  ^ .:   ..     ",
  "          ^            .      .            ~:    ..       ",
  "          ~           ....  ....           ~ .:.          ",
  "          :.          .........           .!:.            ",
  "           ^            ......            ^:              ",
  "           ~              ..              ~               ",
  "           ^.                           . ^               ",
  "             .                         .                  ",
  "             .. _ . .. _ .: _ .. _ . ..                   ",
}

return {
  ------- Theming
  -- {
  --   "goolord/alpha-nvim",
  --   opts = function(_, opts)
  --     -- customize the dashboard header
  --     opts.section.header.val = catcoffee
  --     opts.config.layout[1].val = vim.fn.max { 3, vim.fn.floor(vim.fn.winheight(0) * 0.1) }
  --     opts.config.layout[3].val = 3
  --     opts.config.opts.noautocmd = true
  --     return opts
  --   end,
  -- },
  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      local space_above = vim.fn.max({ 3, vim.fn.floor(vim.fn.winheight(0) * 0.1) })
      local space_below = 3
      local header = {}
      for i = 0, space_above do
        table.insert(header, "")
      end
      for i = 1, #catcoffee do
        table.insert(header, catcoffee[i])
      end
      for i = 0, space_below do
        table.insert(header, "")
      end
      opts.config.header = header
      return opts
    end,
  },
  {
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- mocha, macchiato, frappe, latte
      })
      vim.api.nvim_command("colorscheme catppuccin")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-macchiato",
    },
  },

  ------- Coding related utilities/configurations
  -- TAB completion
  -- remove default LuaSnip keymap
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  -- git blame!
  {
    "f-person/git-blame.nvim",
    config = function()
      require("gitblame").setup({
        delay = 500,
      })
    end,
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 0.6,
      },
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  -- disable cringey indentscope animation
  {
    "echasnovski/mini.indentscope",
    config = function()
      require("mini.indentscope").setup({
        draw = {
          delay = 50,
          animation = require("mini.indentscope").gen_animation.none(),
        },
        symbol = "│",
      })
    end,
  },
  -- codeblocks, I probably want to remove this actually
  {
    "HampusHauffman/block.nvim",
    config = function()
      require("block").setup({})
    end,
  },
  -- code minimap
  {
    "gorbit99/codewindow.nvim",
    config = function()
      local codewindow = require("codewindow")
      codewindow.setup({ exclude_filetypes = { "nvim-tree", "neo-tree", "toggleterm" } })
      codewindow.apply_default_keybinds()
    end,
  },
  -- comment code
  {
    "terrortylor/nvim-comment",
    config = function()
      require("nvim_comment").setup()
    end,
  },
  -- treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "go",
        "dockerfile",
      },
    },
  },
  --
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          -- prefix = "icons",
        },
        severity_sort = true,
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = true,
      },
      ---@type lspconfig.options
      servers = {
        gopls = {
          settings = {
            gopls = {
              codelenses = {
                gc_details = true,
                run_govulncheck = true,
                test = true,
              },
              analyses = {
                fieldalignment = false,
                shadow = true,
              },
            },
          },
        },
        golangci_lint_ls = {
          cmd = { "golangci-lint-langserver", "-debug" },
          init_options = {
            command = { "golangci-lint", "run", "--out-format", "json", "--issues-exit-code=1" },
          },
          filetypes = { "go" },
        },
        yamlls = {
          schemas = {
            ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
            ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
            ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
            ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
            ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*compose*.{yml,yaml}",
          },
        },
      },
    },
  },

  ------- UI customizations
  -- telescope (modal finder thing) customizations
  {
    "nvim-telescope/telescope.nvim",
    -- add telescope-fzf-native
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          { source = "filesystem", display_name = "File" },
          { source = "buffers", display_name = "Bufs" },
          { source = "git_status", display_name = "Git" },
          { source = "diagnostics", display_name = "Diagnostic" },
        },
      },
      window = {
        position = "left",
        width = 35,
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
    },
  },
  -- use C-j, C-k, etc. to navigate to tmux panes from neovim
  { "christoomey/vim-tmux-navigator" },
}

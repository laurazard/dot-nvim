return {
  -- colorscheme
  {
    "rebelot/kanagawa.nvim",
    as = "kanagawa",
    config = function()
      require("kanagawa").setup({
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            -- popup menu
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },

            -- telescope ui modern
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

            -- transparent floating windows
            NormalFloat = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            EdgyNormal = { fg = "none", bg = theme.ui.bg },

            LspLens = { fg = theme.ui.nontext, bg = theme.ui.bg },

            -- LeapBackdrop = { bg = theme.syn.parameter },
            -- LeapMatch = { fg = theme.syn.parameter, bg = theme.syn.parameter },
            LeapLabel = { fg = theme.ui.bg_m3, bg = theme.syn.parameter },

            -- which-key
            WhichKeyNormal = { bg = theme.ui.bg_dim },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

            CursorLine = { bg = theme.ui.bg_p1 },

            -- highlight symbol under cursor
            IlluminatedWordText = { bg = theme.ui.bg_p1, bold = true },
          }
        end,
      })
      vim.api.nvim_command("colorscheme kanagawa")
    end
  },

  -- component library
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },

  -- icons libraries
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    'echasnovski/mini.icons',
    version = false,
    config = function()
      require('mini.icons').setup()
    end
  },

  -- start dashboard
  {
    "nvimdev/dashboard-nvim",
    event = 'VimEnter',
    opts = function(_, opts)
      -- customize the dashboard header
      local space_above = vim.fn.max({ 3, vim.fn.floor(vim.fn.winheight(0) * 0.1) })
      local space_below = 3
      local header = {}

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

      for i = 0, space_above do
        table.insert(header, "")
      end
      for i = 1, #catcoffee do
        table.insert(header, catcoffee[i])
      end
      for i = 0, space_below do
        table.insert(header, "")
      end
      opts.config = {
        header = header,
        shortcut = {
          { action = "lua require('telescope.builtin').find_files()", desc = " Find File", icon = " ", key = "f" },
          { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
          { action = "lua require('telescope.builtin').live_grep()", desc = " Find Text", icon = " ", key = "/" },
          { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
          { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
          { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit", icon = " ", key = "q" },
        },
      }
      return opts
    end,
  },

  -- picker/finder window UI
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    config = function()
      local open_with_trouble = require("trouble.sources.telescope").open
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
              -- even more opts
            }
          }
        },
        defaults = {
          mappings = {
            i = { ["<c-t>"] = open_with_trouble },
            n = { ["<c-t>"] = open_with_trouble },
          },
        },
      }
      require("telescope").load_extension("ui-select")
    end,
  },

  -- code minimap
  {
    "gorbit99/codewindow.nvim",
    lazy = true,
    config = function()
      local codewindow = require("codewindow")
      codewindow.setup({ exclude_filetypes = { "nvim-tree", "neo-tree", "toggleterm" } })
    end,
  },

  -- pretty indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    config = function()
      require("ibl").setup {
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = { show_start = false, show_end = false },
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
        },
      }
    end
  },

  -- git column status indicators
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
          untracked = { text = "▎" },
        },
        signs_staged = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
        },
        on_attach = function(buffer)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
          end

          local wk = require("which-key")

          wk.add({
            { "<leader>g",  group = "git" },
            {
              "<leader>gB",
              function()
                gs.blame()
              end,
              desc = "blame"
            },
            { "<leader>gb", group = "buffer" },
            {
              "<leader>gbs",
              function()
                gs.stage_buffer()
              end,
              desc = "stage buffer",
              mode = "n"
            },
            {
              "<leader>gbr",
              function()
                gs.reset_buffer()
              end,
              desc = "stage buffer",
              mode = "n"
            },
            { "<leader>gh", group = "hunk" },
            {
              "<leader>ghs",
              "<cmd>Gitsigns stage_hunk<CR>",
              desc = "stage hunk",
              mode = "n"
            },
            {
              "<leader>ghr",
              "<cmd>Gitsigns reset_hunk<CR>",
              desc = "reset hunk",
              mode = "n"
            },
            {
              "<leader>ghu",
              function()
                gs.undo_stage_hunk()
              end,
              desc = "undo stage hunk",
              mode = "n"
            },

            { "<leader>gc", group = "copy" },
            {
              "<leader>gcf",
              "<cmd>GitBlameCopyFileURL<cr>",
              desc = "copy file URL",
              mode = "n"
            },
            {
              "<leader>gcc",
              "<cmd>GitBlameCopyCommitURL<cr>",
              desc = "copy commit URL",
              mode = "n"
            },

          })
        end,
      })
    end
  },

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "jackielii/neo-tree-harpoon.nvim" },
    lazy = true,
    opts = {
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      sources = { "filesystem", "buffers", "git_status", "harpoon-buffers" },
      source_selector = {
        -- winbar = true,
        content_layout = "center",
        sources = {
          { source = "filesystem",      display_name = "File" },
          { source = "buffers",         display_name = "Bufs" },
          { source = "git_status",      display_name = "Git" },
          { source = "harpoon-buffers", display_name = "Harpoon" },
          { source = "diagnostics",     display_name = "Diagnostic" },
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

  -- buffer line
  {
    'akinsho/bufferline.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    config = function()
      require("bufferline").setup({
        options = {
          offsets = {
            {
              filetype = "neo-tree",
              text = "Neo-Tree",
              separator = true,
              text_align = "left",
            },
          },
          diagnostics = "nvim_lsp",
          separator_style = { "", "" },
          modified_icon = "●",
          show_close_icon = false,
          show_buffer_close_icons = true,
        },
      })
    end,
  },

  -- status (bottom) line
  {
    'nvim-lualine/lualine.nvim',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = "kanagawa",
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { { 'filename', path = 1 }, },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        }
      })
    end
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      fps = 60,
      stages = "slide",
    }
  },

  -- better messages/popup UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify"
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
      })
    end,
  },

  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      -- wo = {
      -- winhighlight = "",
      -- },
      animate = {
        enabled = false,
      },
      bottom = {
        -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
        {
          ft = "toggleterm",
          size = { height = 0.4 },
          -- exclude floating windows
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        -- {
        --   ft = "trouble",
        --   size = { height = 10, width = 20 },
        --   filter = function(_buf, win)
        --     return vim.w[win].trouble
        --         and not vim.w[win].trouble.position == "right"
        --         -- and vim.w[win].trouble.type == "split"
        --         -- and vim.w[win].trouble.relative == "win"
        --         and not vim.w[win].trouble_preview
        --   end,
        -- },
        { ft = "qf",            title = "QuickFix" },
        {
          ft = "help",
          size = { height = 20 },
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        { ft = "spectre_panel", size = { height = 0.4 } },
      },
      left = {
        -- Neo-tree filesystem always takes half the screen height
        {
          title = "File System",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          size = { height = 0.5 },
        },
        {
          title = "Harpoon Buffers",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "harpoon-buffers"
          end,
          pinned = true,
          open = "Neotree position=top harpoon-buffers",
          size = { height = 0.2 },
        },
        {
          title = "Git Status",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "git_status"
          end,
          pinned = true,
          collapsed = false, -- show window as closed/collapsed on start
          open = "Neotree position=right git_status",
        },


        -- any other neo-tree windows
        "neo-tree",
      },
      -- right = {
      --   {
      --     ft = "trouble",
      --     size = { height = 10, width = 20 },
      --     filter = function(_buf, win)
      --       return vim.w[win].trouble_preview
      --     end,
      --   },
      -- },
    },
  }
}

return {


    -- icons libraries
    {
        "nvim-tree/nvim-web-devicons",
        -- lazy = true,
    },
    {
        'echasnovski/mini.icons',
        version = false,
        config = function()
            require('mini.icons').setup()
        end
    },

    -- picker/finder window UI
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            local open_with_trouble = require("trouble.sources.telescope").open
            require("telescope").setup {
                pickers = {
                    find_files = {
                        hidden = true
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                            -- even more opts
                        }
                    },
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
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
            require("telescope").load_extension("fzf")
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

    -- buffer line (top line with buffers as tabs)
    {
        'akinsho/bufferline.nvim',
        version = "v4.9.0",
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
                    show_buffer_icons = true,
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
            vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
            local git_blame = require('gitblame')

            require('lualine').setup({
                options = {
                    theme = "kanagawa",
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = {
                        {
                            'filename',
                            path = 4,
                        },
                        {
                            git_blame.get_current_blame_text,
                            cond = function()
                                return git_blame.is_blame_text_available and vim.o.columns > 100
                            end,
                            fmt = function(str)
                                local filename_len = string.len(vim.fn.expand('%'))
                                local max_length = vim.o.columns - 35 - filename_len
                                if string.len(str) < max_length then
                                    return " " .. str
                                end
                                return " " .. str:sub(1, max_length) .. "..."
                            end,
                            color = "LuaGitStatus",
                        }
                    },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                }
            })
        end
    },

    -- notifications
    {
        "rcarriga/nvim-notify",
        opts = {
            fps = 60,
            stages = "slide",
        }
    },

    -- better cmdline/notifications view
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
        opts = function()
            local opts = {
                animate = {
                    enabled = false,
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
                bottom = {
                    {
                        title = "Trouble",
                        ft = "trouble",
                        size = { height = 10, width = .2 },
                        filter = function(_buf, win)
                            return vim.w[win].trouble
                                and vim.w[win].trouble.position == "bottom"
                                and vim.w[win].trouble.type == "split"
                                and not vim.w[win].trouble_preview
                        end,
                        wo = {
                            winhighlight = ""
                        },
                    },
                    { title = "Neotest Output",  ft = "neotest-output-panel", size = { width = .2 } },
                    { title = "Neotest Summary", ft = "neotest-summary",      size = { width = 8 } },
                },
                right = {
                },
            }

            return opts
        end
    },

    -- code diagnostics dashboard
    {
        "folke/trouble.nvim",
        opts = function()
            local width = math.floor(vim.o.columns / 2)
            local height = 10
            local x = vim.o.columns - width
            local y = vim.o.lines - height - 1
            local opts = {
                win = {
                    type = "split",
                    position = "bottom",
                },
                preview = {
                    type = "float",
                    relative = "editor",
                    position = { y, x },
                    size = {
                        height = height,
                        width = width,
                    },
                },
            }

            return opts
        end,
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle win.position=bottom<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0 pinned=true win.position=bottom<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false win.position=bottom<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>xr",
                "<cmd>Trouble lsp_references toggle focus=false win.position=bottom<cr>",
                desc = "LSP references (Trouble)",
            },
            {
                "<leader>xi",
                "<cmd>Trouble lsp_implementations toggle focus=false win.position=bottom<cr>",
                desc = "LSP Implementations (Trouble)",
            },
            {
                "<leader>xd",
                "<cmd>Trouble lsp_definitions toggle focus=false win.position=bottom<cr>",
                desc = "LSP Definitions (Trouble)",
            },
            {
                "<leader>xl",
                "<cmd>Trouble lsp toggle focus=false win.position=bottom<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle win.position=bottom<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },

    -- bookmarks for code!
    {
        "ThePrimeagen/harpoon",
        -- event = { "BufReadPre", "BufNewFile" },
        event = "VeryLazy",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require('harpoon')
            harpoon:setup({})

            -- basic telescope configuration
            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(item.value, file_paths)
                end

                require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                }):find()
            end

            vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
                { desc = "Open harpoon window" })
            vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
            vim.keymap.set("n", "<leader>hd", function() harpoon:list():remove() end)
        end
    },
}

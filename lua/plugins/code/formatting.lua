return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                -- Customize or remove this keymap to your liking
                "<leader>cf",
                function()
                    require("conform").format({ async = true })
                end,
                mode = "n",
                desc = "format code",
            },
        },
        -- This will provide type hinting with LuaLS
        ---@module "conform"
        ---@type conform.setupOpts
        opts = {
            -- Define your formatters
            formatters_by_ft = {
                lua = { "stylua" },
                -- python = { "isort", "black" },
                -- javascript = { "prettierd", "prettier", stop_after_first = true },
                -- TODO: move this to language files
                gp = { "gofumpt", "golines", "goimports" },
                sh = { "shfmt" },
            },
            -- Set default options
            default_format_opts = {
                lsp_format = "fallback",
            },
            -- Set up format-on-save
            format_on_save = { timeout_ms = 500 },
            -- Customize formatters
            formatters = {
                shfmt = {
                    prepend_args = { "-i", "2" },
                },
            },
        },
        init = function()
            -- If you want the formatexpr, here is the place to set it
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
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

    -- comment code
    {
        "terrortylor/nvim-comment",
        config = function()
            require("nvim_comment").setup({
                -- disable commenting empty lines
                comment_empty = false,
                line_mapping = "<C-j>",
                operator_mapping = "<C-S-/>",
            })
        end,
    },

    -- highlight symbol under cursor
    {
        "RRethy/vim-illuminate",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            filetypes_denylist = {
                'c',
            },
        },
        config = function(_, opts)
            require('illuminate').configure(opts)
        end
    },

    -- automatically add pair-closing brackets, etc.
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equalent to setup({}) function
    },

}

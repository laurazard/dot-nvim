return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "bash")

            opts.extra_mappings = {
                ["dotenv"] = "bash",
                ["zsh"] = "bash"
            }
            return opts
        end
    },

    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "shfmt")

            return opts
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "bashls")
            return opts
        end
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                bashls = {}
            }
        },
    },
}

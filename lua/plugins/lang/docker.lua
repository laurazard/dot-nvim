return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "dockerfile")

            return opts
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "dockerls")
            table.insert(opts.ensure_installed, "docker_compose_language_service")
            return opts
        end
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                dockerls = {},
                -- provided by yamlls w/ compose_schema
                -- TODO: see if we can have both working together
                -- docker_compose_language_service = {},
            }
        },
    },
}

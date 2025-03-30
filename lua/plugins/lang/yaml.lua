return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "yaml")

            return opts
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "yamlls")
            return opts
        end
    },

    -- provides a bunch of different schemas
    {
        "b0o/SchemaStore.nvim",
        lazy = true,
        version = false, -- last release is way too old
    },
}

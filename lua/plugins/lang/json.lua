return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "json5")

            return opts
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "jsonls")
            return opts
        end
    },

    -- schemas
    {
        "b0o/SchemaStore.nvim",
        lazy = true,
        version = false, -- last release is way too old
    },
}

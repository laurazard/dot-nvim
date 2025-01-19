return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "tlaplus")

            return opts
        end
    },

    {
        "susliko/tla.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        opts = {
            java_executable = "/opt/homebrew/opt/openjdk/bin/java",
        },
        config = function(_, opts)
            require("tla").setup(opts)
        end
    },
}

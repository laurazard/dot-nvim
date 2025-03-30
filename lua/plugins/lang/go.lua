return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "go")
            table.insert(opts.ensure_installed, "gomod")
            table.insert(opts.ensure_installed, "gosum")
            return opts
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "gopls")
            table.insert(opts.ensure_installed, "golangci_lint_ls")
            return opts
        end
    },

    {
        "nvim-neotest/neotest",
        dependencies = { "fredrikaverpil/neotest-golang" },
        opts = {
            adapters = {
                ["neotest-golang"] = {
                    -- Here we can set options for neotest-golang, e.g.
                    -- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
                    dap_go_enabled = true, -- requires leoluz/nvim-dap-go
                },
            }
        }
    }
}

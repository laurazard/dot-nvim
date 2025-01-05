return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "go",
                "gomod",
            }
        }
    },

    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "gopls",
                "golangci_lint_ls",
            }
        },
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                gopls = {
                    settings = {
                        gopls = {
                            verboseOutput = true,
                            codelenses = {
                                gc_details = true,
                                run_govulncheck = true,
                                -- test = true,
                            },
                            analyses = {
                                fieldalignment = false,
                                unusedparams = true,
                                shadow = true,
                            },
                            hints = {
                                rangeVariableTypes = true,
                                parameterNames = true,
                                constantValues = true,
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                functionTypeParameters = true,
                            },
                            staticcheck = true,
                            gofumpt = true,
                            semanticTokens = true,
                            usePlaceholders = true,
                        },
                    },
                }
            }
        },
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

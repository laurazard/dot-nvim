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
                                -- covered by golangci_lint_ls, and that one
                                -- can ignore err/ok shadows
                                shadow = false,
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
                    codeactions_only = {
                        "source",
                        "source.assembly",
                        -- "source.doc", -- this one is responsible for the
                        -- "browse gopls documentation" action
                        "source.fixAll",
                        "source.freesymbols",
                        "source.organizeImports",
                        -- "source.test", -- this causes the LSP to crash (maybe
                        -- because the "test" codelens is disabled
                        "quickfix",
                        "refactor",
                    },
                },
                golangci_lint_ls = {},
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

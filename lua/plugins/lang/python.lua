return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "python")
            return opts
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "basedpyright")
            return opts
        end
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                basedpyright = {
                    settings = {
                        basedpyright = {
                            analysis = {
                                typeCheckingMode = "basic",
                                autoImportCompletions = true,
                                diagnosticSeverityOverrides = {
                                    reportUnusedImport = "information",
                                    reportUnusedFunction = "information",
                                    reportUnusedVariable = "information",
                                    reportGeneralTypeIssues = "none",
                                    reportOptionalMemberAccess = "none",
                                    reportOptionalSubscript = "none",
                                    reportPrivateImportUsage = "none",
                                },
                            },
                        },
                    },
                },
            }
        },
    },

}

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

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                yamlls = {
                    -- schemas for language server
                    schemas = {
                        ["http://json.schemastore.org/github-workflow"] =
                        ".github/workflows/*.{yml,yaml}",
                        ["http://json.schemastore.org/github-action"] =
                        ".github/action.{yml,yaml}",
                        ["http://json.schemastore.org/ansible-stable-2.9"] =
                        "roles/tasks/*.{yml,yaml}",
                        ["https://json.schemastore.org/dependabot-v2"] =
                        ".github/dependabot.{yml,yaml}",
                        ["https://json.schemastore.org/gitlab-ci"] =
                        "*gitlab-ci*.{yml,yaml}",
                        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
                        "*compose*.{yml,yaml}",
                    },
                    capabilities = {
                        textDocument = {
                            foldingRange = {
                                dynamicRegistration = false,
                                lineFoldingOnly = true,
                            },
                        },
                    },
                    settings = {
                        format = {
                            enable = true,
                        },
                    },
                },
                -- builtin from lspconfig
                -- on_new_config = function(new_config)
                -- end
            },
        },
    },
}

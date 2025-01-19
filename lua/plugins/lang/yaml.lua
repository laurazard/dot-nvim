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

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                yamlls = {
                    -- schemas for language server
                    -- disabled because these are provided by schemastore.nvim
                    -- schemas = {
                    --     ["http://json.schemastore.org/github-workflow"] =
                    --     ".github/workflows/*.{yml,yaml}",
                    --     ["http://json.schemastore.org/github-action"] =
                    --     ".github/action.{yml,yaml}",
                    --     ["http://json.schemastore.org/ansible-stable-2.9"] =
                    --     "roles/tasks/*.{yml,yaml}",
                    --     ["https://json.schemastore.org/dependabot-v2"] =
                    --     ".github/dependabot.{yml,yaml}",
                    --     ["https://json.schemastore.org/gitlab-ci"] =
                    --     "*gitlab-ci*.{yml,yaml}",
                    --     ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
                    --     "*compose*.{yml,yaml}",
                    -- },
                    capabilities = {
                        textDocument = {
                            foldingRange = {
                                dynamicRegistration = false,
                                lineFoldingOnly = true,
                            },
                        },
                    },
                    settings = {
                        keyOrdering = false,
                        format = {
                            enable = true,
                        },
                        validate = true,
                        schemaStore = {
                            -- Must disable built-in schemaStore support to use
                            -- schemas from SchemaStore.nvim plugin
                            enable = false,
                            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                            url = "",
                        },
                    },
                    -- lazy-load schemastore when needed
                    on_new_config = function(new_config)
                        new_config.settings.yaml.schemas = vim.tbl_deep_extend(
                            "force",
                            new_config.settings.yaml.schemas or {},
                            require("schemastore").yaml.schemas()
                        )
                    end,
                },
            },
        },
    },
}

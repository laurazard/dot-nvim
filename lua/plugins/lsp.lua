require("lib.lsp_utils")

function TABLE_MERGE(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                TABLE_MERGE(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

return {
    {
        import = "plugins.lang"
    },

    {
        "williamboman/mason.nvim",
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")

            mr.refresh(function()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end)
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
        end
    },

    {
        "neovim/nvim-lspconfig",
        lazy = true,
        dependencies = { "williamboman/mason-lspconfig.nvim" },
    },

    {
        "VidocqH/lsp-lens.nvim",
        opts = function(_, opts)
            opts.sections = {
                definition = true,
                git_authors = true,
            }
            local SymbolKind = vim.lsp.protocol.SymbolKind
            opts.target_symbol_kinds = {
                SymbolKind.Function,
                SymbolKind.Method,
                SymbolKind.Interface,
                SymbolKind.Class,
                SymbolKind.Struct,
            }
        end,
        config = function(_, opts)
            require("lsp-lens").setup(opts)
        end
    },

    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy", -- Or `LspAttach`
        priority = 1000,    -- needs to be loaded in first
        opts = {
            preset = "modern",
            hi = {
                --     error = "DiagnosticVirtualTextError",
                --     warn = "DiagnosticVirtualTextWarn",
                --     info = "DiagnosticVirtualTextInfo",
                --     hint = "DiagnosticHint",
                -- arrow = "none",
                --     background = "CursorLine", -- Can be a highlight or a hexadecimal color (#RRGGBB)
                --     mixing_color = "None",     -- Can be None or a hexadecimal color (#RRGGBB). Used to blend the background color with the diagnostic background color with another color.
            },
            options = {
                use_icons_from_diagnostic = true,
                multilines = {
                    enabled = true,
                    always_show = true,
                },
                virt_texts = {
                    priority = 10000,
                },
                show_source = true,
                throttle = 0,
                -- Display all diagnostic messages on the cursor line
                show_all_diags_on_cursorline = true,

                -- Enable diagnostics in Insert mode
                -- If enabled, it is better to set the `throttle` option to 0 to avoid visual artifacts
                enable_on_insert = true,
            },
            signs = {
                left = "",
                right = "",
            }
        },
        config = function(_, opts)
            vim.diagnostic.config({ virtual_text = false })
            require('tiny-inline-diagnostic').setup(opts)
        end
    }
}

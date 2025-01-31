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
        -- event = "LazyFile",
        dependencies = { "williamboman/mason.nvim" },
        config = function(_, opts)
            -- dump = function(o)
            --     if type(o) == 'table' then
            --         local s = '{ '
            --         for k, v in pairs(o) do
            --             if type(k) ~= 'number' then k = '"' .. k .. '"' end
            --             s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
            --         end
            --         return s .. '} '
            --     else
            --         return tostring(o)
            --     end
            -- end
            -- require("notify")(dump(opts))
            require("mason-lspconfig").setup(opts)
        end
    },

    {
        "neovim/nvim-lspconfig",
        event = 'LazyFile',
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    -- prefix = "●",
                    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
                    prefix = "icons",
                },
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.HINT] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                    },
                },
            },
            -- extended in plugins.lang
            servers = {},
        },
        config = function(_, opts)
            -- diagnostics signs
            if type(opts.diagnostics.signs) ~= "boolean" then
                for severity, icon in pairs(opts.diagnostics.signs.text) do
                    local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
                    name = "DiagnosticSign" .. name
                    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
                end
            end

            if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
                opts.diagnostics.virtual_text.prefix = function(diagnostic)
                    for d, icon in pairs(opts.diagnostics.signs.text) do
                        if diagnostic.severity == d then
                            return icon
                        end
                    end
                end
            end

            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            vim.api.nvim_create_augroup("autoformat_on_save", { clear = true })
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            for server_name, lsp_config in pairs(opts.servers) do
                local specific_capabilities = capabilities
                -- merge specific capabilities
                if lsp_config.capabilities then
                    TABLE_MERGE(specific_capabilities, lsp_config.capabilities)
                end
                local codeactions_only = nil
                if lsp_config.codeactions_only then
                    codeactions_only = lsp_config.codeactions_only
                end
                lsp_config.capabilities = specific_capabilities
                if lsp_config.capabilities_only then
                    lsp_config.capabilities = lsp_config.capabilities_only
                end

                lsp_config.on_attach = CONFIGURE_LS_ON_ATTACH(codeactions_only)
                require("lspconfig")[server_name].setup(lsp_config)
            end
        end,
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

                -- Enable diagnostics in Select mode (e.g when auto inserting with Blink)
                enable_on_select = true,
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

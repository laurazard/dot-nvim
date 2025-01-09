CONFIGURE_LS_ON_ATTACH = function(autoformat)
    return function(client, bufnr)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "code actions" })
        vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { buffer = bufnr, desc = "run codelens" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "goto definition" })
        vim.keymap.set("n", "gi", function()
            require("telescope.builtin").lsp_implementations()
        end, { buffer = bufnr, desc = "goto implementations" })
        vim.keymap.set("n", "gr", function()
            require('telescope.builtin').lsp_references()
            -- TODO: new thing to do this but in quickfix window
        end, { buffer = bufnr, desc = "find references" })
        vim.keymap.set("n", "<leader>cr", function()
            vim.lsp.buf.rename()
        end, { buffer = bufnr, desc = "rename symbol" })
        vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float,
            { buffer = bufnr, desc = "open diagnostics for line" })

        -- autoformat on save
        if autoformat and client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = "autoformat_on_save", buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = "autoformat_on_save",
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format()
                end,
            })
        end

        if client.supports_method("textDocument/codeAction") then
            vim.api.nvim_clear_autocmds({ group = "autoformat_on_save", buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = "autoformat_on_save",
                -- pattern = "*.go",
                buffer = bufnr,
                callback = function()
                    local params = vim.lsp.util.make_range_params()
                    params.context = { only = { "source.organizeImports" } }
                    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
                    -- machine and codebase, you may want longer. Add an additional
                    -- argument after params if you find that you have to write the file
                    -- twice for changes to be saved.
                    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                    for cid, res in pairs(result or {}) do
                        for _, r in pairs(res.result or {}) do
                            if r.edit then
                                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                                vim.lsp.util.apply_workspace_edit(r.edit, enc)
                            end
                        end
                    end
                    vim.lsp.buf.format({ async = false })
                end
            })
        end

        -- inlay hints
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
        end

        -- semantic token highlighting
        if client.server_capabilities.semanticTokensProvider then
            -- remap colorscheme highlight groups for semantic tokens
            local links = {
                -- ['@lsp.type.namespace'] = '@namespace',
                -- ['@lsp.type.type'] = '@type',
                -- ['@lsp.type.class'] = '@type',
                -- ['@lsp.type.enum'] = '@type',
                -- ['@lsp.type.interface'] = '@type',
                -- ['@lsp.type.struct'] = '@structure',
                -- ['@lsp.type.parameter'] = '@parameter',
                -- ['@lsp.type.variable'] = '@variable',
                -- ['@lsp.type.property'] = '@property',
                -- ['@lsp.type.enumMember'] = '@constant',
                -- ['@lsp.type.function'] = '@function',
                -- ['@lsp.type.method'] = '@method',
                -- ['@lsp.type.macro'] = '@macro',
                -- ['@lsp.type.decorator'] = '@function',
                -- ['@lsp.type.keyword.go'] = '@keyword.return.go'
            }
            for newgroup, oldgroup in pairs(links) do
                vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
            end

            vim.lsp.semantic_tokens.start(bufnr, client.id)
        end

        -- code lens
        vim.lsp.codelens.refresh()
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.codelens.refresh()
            end
        })
    end
end

return {
    {
        import = "plugins.lang"
    },

    {
        "williamboman/mason.nvim",
        config = function(_, opts)
            require("mason").setup(opts)
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
                lsp_config.capabilities = capabilities
                lsp_config.on_attach = CONFIGURE_LS_ON_ATTACH(true)
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
}

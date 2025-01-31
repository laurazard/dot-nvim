--- Corresponds to context.only param of the vim.lsp.buf.code_action request
--- Use this to disable code actions, such as Go's "browse gopls documentation"
---@param codeactions_only? string[]
CONFIGURE_LS_ON_ATTACH = function(codeactions_only)
    --- @inlinedoc
    --- @param client vim.lsp.Client
    return function(client, bufnr)
        local code_action_fn = function()
            local opts = nil
            if codeactions_only then
                opts = {
                    context = {
                        only = codeactions_only
                    }
                }
            end
            vim.lsp.buf.code_action(opts)
        end
        vim.keymap.set("n", "<leader>ca", code_action_fn, { buffer = bufnr, desc = "code actions" })
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

        -- workaround for formatting w/ yamlls
        -- FIXME: extract this from generic on_attach func and make configurable
        -- see: https://github.com/LazyVim/LazyVim/commit/7f5051ef72cfe66eb50ddb7c973714aa8aea04ec
        if client.name == "yamlls" then
            client.server_capabilities.documentFormattingProvider = true
        end

        -- autoformat on save
        if client:supports_method("textDocument/formatting") and not (client.name == "clangd" or client.name == "ccls") then
            vim.api.nvim_clear_autocmds({ group = "autoformat_on_save", buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = "autoformat_on_save",
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format()
                end,
            })
        end

        if client:supports_method("textDocument/codeAction") and not (client.name == "clangd" or client.name == "ccls") then
            vim.api.nvim_clear_autocmds({ group = "autoformat_on_save", buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = "autoformat_on_save",
                pattern = "*.go",
                callback = function()
                    local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
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
        if client.server_capabilities.semanticTokensProvider and not (client.name == "clangd" or client.name == "ccls") then
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
        if not (client.name == "clangd" or client.name == "ccls") then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufWritePre", "BufEnter", "CursorHold", "InsertLeave" }, {
                buffer = bufnr,
                callback = function()
                    vim.lsp.codelens.refresh()
                end
            })
        end
    end
end

local diagnostics = {
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
}

-- diagnostics signs
if type(diagnostics.signs) ~= "boolean" then
    for severity, icon in pairs(diagnostics.signs.text) do
        local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    end
end

if type(diagnostics.virtual_text) == "table" and diagnostics.virtual_text.prefix == "icons" then
    diagnostics.virtual_text.prefix = function(diagnostic)
        for d, icon in pairs(diagnostics.signs.text) do
            if diagnostic.severity == d then
                return icon
            end
        end
    end
end

vim.diagnostic.config(vim.deepcopy(diagnostics))

vim.api.nvim_create_augroup("autoformat_on_save", { clear = true })
local create_autoformat_on_save_autocmd = function(client, bufnr)
    vim.api.nvim_clear_autocmds({ group = "autoformat_on_save", buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = "autoformat_on_save",
        buffer = bufnr,
        callback = function()
            local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
            params.context = { only = { "source.organizeImports" } }
            -- params.context = { only = { "source.sortImports" } }

            -- buf_request_sync defaults to a 1000ms timeout. Depending on your
            -- machine and codebase, you may want longer. Add an additional
            -- argument after params if you find that you have to write the file
            -- twice for changes to be saved.
            -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
            local result = client:request_sync("textDocument/codeAction", params)
            -- local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
            for _, r in pairs(result or {}) do
                if r.edit then
                    local enc = client.offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
            vim.lsp.buf.format({ async = false })
        end
    })
end

local create_autoformat_on_save_autocmd_without_source = function(client, bufnr)
    vim.api.nvim_clear_autocmds({ group = "autoformat_on_save", buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = "autoformat_on_save",
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format()
        end,
    })
end

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        local bufnr = event.buf
        local client_id = event.data.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        if client == nil then
            require("notify")("LspAttach: failed to get client by id")
            return
        end

        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
            { buffer = bufnr, desc = "code actions" })
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
        if client:supports_method("textDocument/formatting") then
            if client:supports_method("textDocument/codeAction") then
                create_autoformat_on_save_autocmd(client, bufnr)
                local autoformat_on_save_enabled = true
                vim.api.nvim_buf_create_user_command(0, "OrganizeSourcesOnSave", function()
                    if not autoformat_on_save_enabled then
                        require("notify")("disabled source organize on save ")
                        create_autoformat_on_save_autocmd(client, bufnr)
                    else
                        require("notify")("enabled source organize on save ")
                        create_autoformat_on_save_autocmd_without_source(client, bufnr)
                    end
                    autoformat_on_save_enabled = not autoformat_on_save_enabled
                end, {})
            else
                create_autoformat_on_save_autocmd_without_source()
            end
        end

        -- inlay hints
        if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true)
        end

        -- code lens
        if client:supports_method("textDocument/codeLens") then
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                buffer = bufnr,
                callback = function()
                    vim.lsp.codelens.refresh()
                end
            })
        end

        -- semantic token highlighting
        if client:supports_method("textDocument/semanticTokens/full") then
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
    end,
})


-- This is copied straight from blink
-- https://cmp.saghen.dev/installation#merging-lsp-capabilities
local capabilities = {
    textDocument = {
        foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        },
    },
}

capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

-- Setup language servers.
vim.lsp.config("*", {
    capabilities = capabilities,
    root_markers = { ".git" },
})

-- Enable each language server by filename under the lsp/ folder
vim.lsp.enable({
    "basedpyright",
    "bashls",
    "dockerls",
    "golangci_lint_ls",
    "gopls",
    "jsonls",
    "luals",
    "taplo",
    "yamlls"
})

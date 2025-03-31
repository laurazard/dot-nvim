---@type vim.lsp.Config
return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc' },
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim', 'require' },
                disable = { "missing-fields" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files and plugins
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = false,
            },
        }
    },
}

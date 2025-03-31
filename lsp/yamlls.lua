---@type vim.lsp.Config
return {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
    single_file_support = true,
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
        yaml = {
            schemas = require("schemastore").yaml.schemas()
        },
    },
}

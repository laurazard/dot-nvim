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
    -- workaround for formatting w/ yamlls
    -- FIXME: extract this from generic on_attach func and make configurable
    -- see: https://github.com/LazyVim/LazyVim/commit/7f5051ef72cfe66eb50ddb7c973714aa8aea04ec
    on_init = function(_, init_result)
        local new_capabilities = init_result.capabilities
        new_capabilities.documentFormattingProvider = true
    end
}

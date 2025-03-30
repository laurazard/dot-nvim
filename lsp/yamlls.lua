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
    },
    -- lazy-load schemastore when needed
    on_new_config = function(new_config)
        new_config.settings.yaml.schemas = vim.tbl_deep_extend(
            "force",
            new_config.settings.yaml.schemas or {},
            require("schemastore").yaml.schemas()
        )
    end,
}

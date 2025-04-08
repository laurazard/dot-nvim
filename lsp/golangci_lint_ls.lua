---@type vim.lsp.Config
return {
    cmd = { 'golangci-lint-langserver' },
    filetypes = { 'go', 'gomod' },
    init_options = {
        command = { 'golangci-lint', 'run', '--out-format=json', '--show-stats=false' },
    }
}

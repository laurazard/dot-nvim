---@type vim.lsp.Config
return {
    cmd = { 'golangci-lint-langserver' },
    filetypes = { 'go', 'gomod' },
    init_options = {
        command = { 'golangci-lint', 'run',
            '--output.json.path=stdout',
            '--output.text.path=stderr',
            '--output.text.print-linter-name=false',
            '--output.text.print-issued-lines=false',
            '--show-stats=false', '--issues-exit-code=1' },
    }
}

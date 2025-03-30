---@type vim.lsp.Config
return {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gosum' },
    root_markers = {
        'go.mod',
        'go.sum',
    },
    settings = {
        gopls = {
            verboseOutput = true,
            codelenses = {
                gc_details = true,
                run_govulncheck = true,
                -- test = true,
            },
            analyses = {
                fieldalignment = false,
                unusedparams = true,
                -- covered by golangci_lint_ls, and that one
                -- can ignore err/ok shadows
                shadow = false,
            },
            hints = {
                rangeVariableTypes = true,
                parameterNames = true,
                constantValues = true,
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                functionTypeParameters = true,
            },
            staticcheck = true,
            gofumpt = true,
            semanticTokens = true,
            usePlaceholders = true,
        },
    },
}

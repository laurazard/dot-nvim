---@type vim.lsp.Config
return {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    single_file_support = true,
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                autoImportCompletions = true,
                diagnosticMode = 'openFilesOnly',
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
                diagnosticSeverityOverrides = {
                    reportUnusedImport = "information",
                    reportUnusedFunction = "information",
                    reportUnusedVariable = "information",
                    reportGeneralTypeIssues = "none",
                    reportOptionalMemberAccess = "none",
                    reportOptionalSubscript = "none",
                    reportPrivateImportUsage = "none",
                },
            },
        },
    }
}

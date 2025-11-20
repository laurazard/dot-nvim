---@type vim.lsp.Config
return {
    -- mason adds `vim.fn.stdpath("data") .. "/mason/bin/"` to VIM's PATH
    -- hence, packages installed by mason will be found just by name, i.e.
    -- basedpyright-langserver
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

require("lib.lsp_utils")

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "c")
            return opts
        end
    },

    -- use CCLS instead of clangd
    -- it's a lot faster, index cache actually works, etc.
    {
        "ranjithshegde/ccls.nvim",
        event = "LazyFile",
        config = function(_, opts)
            opts = opts or {}
            opts.lsp = opts.lsp or {}

            local util = require "lspconfig.util"
            local server_config = {
                filetypes = { "c", "cpp", "objc", "objcpp", "opencl" },
                root_dir = function(fname)
                    return util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname)
                        or util.find_git_ancestor(fname)
                end,
                init_options = {
                    cache = {
                        directory = vim.fs.normalize "~/.cache/ccls" -- if on nvim 0.8 or higher
                    }
                },
            }
            opts.lsp.lspconfig = server_config
            require("ccls").setup(opts)
        end
    },
}

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

            local server_config = {
                filetypes = { "c", "cpp", "objc", "objcpp", "opencl" },
                init_options = {
                    cache = {
                        directory = vim.fs.normalize "~/.cache/ccls" -- if on nvim 0.8 or higher
                    }
                },
            }
            opts.lsp.server = server_config
            require("ccls").setup(opts)
        end
    },
}

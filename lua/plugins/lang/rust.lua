return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "rust")
            table.insert(opts.ensure_installed, "ron")
            return opts
        end
    },

    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "codelldb")
            return opts
        end
    },

    {
        "VidocqH/lsp-lens.nvim",
    },

    {
        "mrcjkb/rustaceanvim",
        event = "LazyFile",
        version = vim.fn.has("nvim-0.10.0") == 0 and "^4" or false,
        ft = { "rust" },
        opts = {
            server = {
                default_settings = {
                    -- rust-analyzer language server configuration
                    ["rust-analyzer"] = {
                        cargo = {
                            allTargets = false,
                            buildScripts = {
                                enable = true,
                            },
                        },
                        -- Add clippy lints for Rust if using rust-analyzer
                        checkOnSave = true,
                        -- Enable diagnostics if using rust-analyzer
                        diagnostics = {
                            enable = true,
                        },
                        -- disable implementations/reference lens in favor of
                        -- lsp-lens.nvim
                        lens = {
                            implementations = {
                                enable = false
                            },
                            references = {
                                adt = {
                                    enable = false
                                },
                                method = {
                                    enable = false
                                },
                                trait = {
                                    enable = false
                                }
                            }
                        },
                        procMacro = {
                            enable = true,
                            ignored = {
                                ["async-trait"] = { "async_trait" },
                                ["napi-derive"] = { "napi" },
                                ["async-recursion"] = { "async_recursion" },
                            },
                        },
                        files = {
                            excludeDirs = {
                                ".direnv",
                                ".git",
                                ".github",
                                ".gitlab",
                                "bin",
                                "node_modules",
                                "target",
                                "venv",
                                ".venv",
                            },
                        },
                    },
                },
                on_attach = function(_, bufnr)
                    vim.keymap.set("n", "<leader>dr", function()
                        vim.cmd.RustLsp("debuggables")
                    end, { desc = "Rust Debuggables", buffer = bufnr })
                end,
            },
        },
        config = function(_, opts)
            local codelldb = vim.fn.exepath("codelldb")
            local codelldb_lib_ext = io.popen("uname"):read("*l") == "Linux" and ".so" or ".dylib"
            local library_path = vim.fn.expand("$MASON/opt/lldb/lib/liblldb" .. codelldb_lib_ext)
            opts.dap = {
                adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
            }
            vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
            if vim.fn.executable("rust-analyzer") == 0 then
                require("notify")(
                    "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
                    vim.log.levels.WARN, {
                        title = "rustaceanvim"
                    })
            end
        end,
    },

    -- LSP for Cargo.toml
    {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
            completion = {
                crates = {
                    enabled = true,
                },
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
        },
    },
}

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
        opts = {
            -- rustaceanvim provides this
            -- ignore_filetype = {
            --     "rust",
            -- },
        }
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
                on_attach = function(client, bufnr)
                    CONFIGURE_LS_ON_ATTACH(nil)(client, bufnr)
                    vim.keymap.set("n", "<leader>dr", function()
                        vim.cmd.RustLsp("debuggables")
                    end, { desc = "Rust Debuggables", buffer = bufnr })
                end,
            },
        },
        config = function(_, opts)
            local diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    -- prefix = "●",
                    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
                    prefix = "icons",
                },
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.HINT] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                    },
                },
            }

            -- diagnostics signs
            if type(diagnostics.signs) ~= "boolean" then
                for severity, icon in pairs(diagnostics.signs.text) do
                    local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
                    name = "DiagnosticSign" .. name
                    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
                end
            end

            if type(diagnostics.virtual_text) == "table" and diagnostics.virtual_text.prefix == "icons" then
                diagnostics.virtual_text.prefix = function(diagnostic)
                    for d, icon in pairs(diagnostics.signs.text) do
                        if diagnostic.severity == d then
                            return icon
                        end
                    end
                end
            end

            vim.diagnostic.config(vim.deepcopy(diagnostics))

            local package_path = require("mason-registry").get_package("codelldb"):get_install_path()
            local codelldb = package_path .. "/extension/adapter/codelldb"
            local library_path = package_path .. "/extension/lldb/lib/liblldb.dylib"
            local uname = io.popen("uname"):read("*l")
            if uname == "Linux" then
                library_path = package_path .. "/extension/lldb/lib/liblldb.so"
            end
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

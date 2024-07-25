return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  {
    "neovim/nvim-lspconfig",
    event = 'VimEnter',
    dependencies = {
      "mason.nvim",
      { "williamboman/mason-lspconfig.nvim", config = function() end },
    },
    opts = function()
      return {
        -- options for vim.diagnostic.config()
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            -- prefix = "icons",
          },
          severity_sort = true,
        },
        servers = {
          gopls = {
            settings = {
              gopls = {
                codelenses = {
                  gc_details = true,
                  run_govulncheck = true,
                  test = true,
                },
                analyses = {
                  fieldalignment = true,
                  shadow = true,
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
              },
            },
          },
          golangci_lint_ls = {
            cmd = { "golangci-lint-langserver", "-debug" },
            init_options = {
              command = { "golangci-lint", "run", "--out-format", "json", "--issues-exit-code=1" },
            },
            filetypes = { "go" },
          },
        },
      }
    end,
    config = function(_, opts)
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "gopls", "golangci_lint_ls", "yamlls" },
      }
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require("lspconfig").yamlls.setup {
        schemas = {
          ["http://json.schemastore.org/github-workflow"] =
          ".github/workflows/*.{yml,yaml}",
          ["http://json.schemastore.org/github-action"] =
          ".github/action.{yml,yaml}",
          ["http://json.schemastore.org/ansible-stable-2.9"] =
          "roles/tasks/*.{yml,yaml}",
          ["https://json.schemastore.org/dependabot-v2"] =
          ".github/dependabot.{yml,yaml}",
          ["https://json.schemastore.org/gitlab-ci"] =
          "*gitlab-ci*.{yml,yaml}",
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
          "*compose*.{yml,yaml}",
        },
      }

      vim.api.nvim_create_augroup("autoformat_on_save", { clear = true })
      require("lspconfig").lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        },
        on_attach = function(client, bufnr)
          -- autoformat on save
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = "autoformat_on_save", buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = "autoformat_on_save",
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end
        end
      }

      require("lspconfig").gopls.setup {
        settings = {
          gopls = {
            codelenses = {
              gc_details = true,
              run_govulncheck = true,
              test = true,
            },
            analyses = {
              fieldalignment = true,
              unusedparams = true,
              shadow = true,
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
            usePlaceholders = true,
          },
        },
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "code actions" })
          vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { desc = "run codelens" })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "goto definition" })
          vim.keymap.set("n", "gr",
            function()
              require('telescope.builtin').lsp_references()
            end,
            { buffer = bufnr, desc = "find references" })

          -- autoformat on save
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = "autoformat_on_save", buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = "autoformat_on_save",
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end

          -- inlay hints
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          end

          -- code lens
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
          })
        end
      }
      require("lspconfig").golangci_lint_ls.setup {
        -- on_attach = function(client, bufnr)
        --   if client.server_capabilities.inlayHintProvider then
        --     vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        --   end
        -- end
      }
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
    end,
  },
}

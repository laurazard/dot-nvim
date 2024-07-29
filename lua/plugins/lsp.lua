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
              fieldalignment = false,
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
            -- semanticTokens = true,
            usePlaceholders = true,
          },
        },
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "code actions" })
          vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { buffer = bufnr, desc = "run codelens" })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "goto definition" })
          vim.keymap.set("n", "gi", function()
            require("telescope.builtin").lsp_implementations()
          end, { buffer = bufnr, desc = "goto implementations" })
          vim.keymap.set("n", "gr", function()
            require('telescope.builtin').lsp_references()
          end, { buffer = bufnr, desc = "find references" })
          vim.keymap.set("n", "<leader>cr", function()
            vim.lsp.buf.rename()
          end, { buffer = bufnr, desc = "rename symbol" })
          vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float,
            { buffer = bufnr, desc = "open diagnostics for line" })

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

          if client.supports_method("textDocument/codeAction") then
            vim.api.nvim_clear_autocmds({ group = "autoformat_on_save", buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = "autoformat_on_save",
              -- pattern = "*.go",
              buffer = bufnr,
              callback = function()
                local params = vim.lsp.util.make_range_params()
                params.context = { only = { "source.organizeImports" } }
                -- buf_request_sync defaults to a 1000ms timeout. Depending on your
                -- machine and codebase, you may want longer. Add an additional
                -- argument after params if you find that you have to write the file
                -- twice for changes to be saved.
                -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                for cid, res in pairs(result or {}) do
                  for _, r in pairs(res.result or {}) do
                    if r.edit then
                      local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                      vim.lsp.util.apply_workspace_edit(r.edit, enc)
                    end
                  end
                end
                vim.lsp.buf.format({ async = false })
              end
            })
          end

          -- inlay hints
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
            vim.keymap.set("n", "<leader>ch", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
              end,
              { buffer = bufnr, desc = "toggle inlay hints" })
          end

          -- semantic token highlighting
          -- if client.server_capabilities.semanticTokensProvider then
          --   -- remap colorscheme highlight groups for semantic tokens
          --   local links = {
          --     ['@lsp.type.namespace'] = '@namespace',
          --     ['@lsp.type.type'] = '@type',
          --     ['@lsp.type.class'] = '@type',
          --     ['@lsp.type.enum'] = '@type',
          --     ['@lsp.type.interface'] = '@type',
          --     ['@lsp.type.struct'] = '@structure',
          --     ['@lsp.type.parameter'] = '@parameter',
          --     ['@lsp.type.variable'] = '@variable',
          --     ['@lsp.type.property'] = '@property',
          --     ['@lsp.type.enumMember'] = '@constant',
          --     ['@lsp.type.function'] = '@function',
          --     ['@lsp.type.method'] = '@method',
          --     ['@lsp.type.macro'] = '@macro',
          --     ['@lsp.type.decorator'] = '@function',
          --   }
          --   for newgroup, oldgroup in pairs(links) do
          --     vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
          --   end
          --
          --   vim.lsp.semantic_tokens.start(bufnr, client.id)
          -- end

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

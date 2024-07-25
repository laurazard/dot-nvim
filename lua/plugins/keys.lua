return {
  -- key mappings/indicators
  {
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")
      wk.setup({
        delay = 0
      })
      wk.add({
        {
          "<leader>e",
          function()
            require("neo-tree")
            vim.cmd("Neotree toggle")
          end,
          desc = "file explorer",
          mode = "n",
          icon = {
            icon = require("mini.icons").get("directory", "nvim"),
            hl = "none",
            color = "azure"
          }
        },
        { "<leader>f", group = "find" },
        {
          "<leader>fb",
          function()
            require('telescope.builtin').buffers()
          end,
          desc = "find buffers",
          mode = "n"
        },
        {
          "<leader>ff",
          function()
            require('telescope.builtin').find_files()
          end,
          desc = "find files",
          mode = "n"
        },

        { "<leader>c", group = "code" },
        {
          "<leader>cf",
          "<cmd>lua vim.lsp.buf.format{async=true}<cr>",
          desc = "format code",
          mode = "n"
        },
        {
          "<leader>cm",
          function()
            require("codewindow").toggle_minimap()
          end,
          desc = "toggle code minimap"
        },

        { "<leader>x", group = "diagnostics" },

        {
          "<leader>/",
          function()
            require('telescope.builtin').live_grep()
          end,
          desc = "live grep",
          icon = {
            icon = "",
            hl = "none",
            color = "green"
          },
        },

        {
          "<leader>n",
          "<cmd>Telescope notify<cr>",
          desc = "notifications",
        },

        {
          "<leader>u",
          "<cmd>undotreetoggle<cr>",
          desc = "undo tree",
          icon = {
            icon = "↺",
            hl = "none",
            color = "orange"
          }
        },


        { "<leader>b", group = "buffer" },
        {
          "<leader>bd",
          "<cmd>Bdelete<cr>",
          desc = "delete buffer"
        },
        {
          "<leader>bn",
          "<cmd>enew<cr>",
          desc = "new buffer"
        },

        {
          "<leader>b?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "buffer-local keymaps"
        },

        {
          "<leader>Q",
          function()
            vim.api.nvim_input("<cmd>qa<cr>")
          end,
          desc = "quit",
          icon = {
            icon = "",
            hl = "none",
            color = "red"
          },
        },
      })
    end
  },
}

return {
    -- key mappings/indicators
    {
        "folke/which-key.nvim",
        config = function()
            local wk = require("which-key")
            wk.setup({
                delay = 0,
                preset = "helix",
                win = {
                    padding = { 1, 4 },
                    border = "none"
                },
                show_help = false,
                show_keys = false,
            })

            local neotree_open = false
            local toggle_neotree = function()
                require("neo-tree")
                if not neotree_open then
                    vim.cmd("Neotree show")
                    vim.cmd("Neotree show position=right git_status")
                    vim.cmd("Neotree show position=top harpoon-buffers")
                else
                    vim.cmd("Neotree close")
                end
                neotree_open = not neotree_open
            end
            wk.add({
                {
                    "<leader>e",
                    toggle_neotree,
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
                    "<leader>cm",
                    function()
                        require("codewindow").toggle_minimap()
                    end,
                    desc = "toggle code minimap"
                },

                { "<leader>d", group = "debug" },
                {
                    "<leader>h",
                    group = "harpoon",
                    icon = {
                        icon = "🪝",
                        hl = "none",
                    }
                },
                { "<leader>o", group = "org mode" },

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

                { "<leader>n", group = "notifications" },
                {
                    "<leader>nn",
                    "<cmd>Telescope notify<cr>",
                    desc = "notifications",
                },
                {
                    "<leader>nd",
                    function()
                        require("notify").dismiss({})
                    end,
                    desc = "dismiss notifications",
                },

                {
                    "<leader>u",
                    "<cmd>UndotreeToggle<cr>",
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
                    "<leader>bD",
                    function()
                        local bd = require('bufdelete')

                        -- Delete all but current buffer
                        local bufs = vim.api.nvim_list_bufs()
                        local current_buf = vim.api.nvim_get_current_buf()
                        for _, i in ipairs(bufs) do
                            if i ~= current_buf then
                                bd.bufdelete(i, true)
                            end
                        end
                    end,
                    desc = "delete all other buffers"
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

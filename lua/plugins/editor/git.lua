return {
    -- git column status indicators
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "▎" },
                    change = { text = "▎" },
                    delete = { text = "" },
                    topdelete = { text = "" },
                    changedelete = { text = "▎" },
                    untracked = { text = "▎" },
                },
                signs_staged = {
                    add = { text = "▎" },
                    change = { text = "▎" },
                    delete = { text = "" },
                    topdelete = { text = "" },
                    changedelete = { text = "▎" },
                },
                on_attach = function()
                    local gs = package.loaded.gitsigns

                    -- local function map(mode, l, r, desc)
                    --     vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                    -- end

                    local wk = require("which-key")

                    wk.add({
                        { "<leader>g",  group = "git" },
                        {
                            "<leader>gB",
                            function()
                                gs.blame()
                            end,
                            desc = "blame"
                        },
                        { "<leader>gb", group = "buffer" },
                        {
                            "<leader>gbs",
                            function()
                                gs.stage_buffer()
                            end,
                            desc = "stage buffer",
                            mode = "n"
                        },
                        {
                            "<leader>gbr",
                            function()
                                gs.reset_buffer()
                            end,
                            desc = "reset buffer",
                            mode = "n"
                        },
                        { "<leader>gh", group = "hunk" },
                        {
                            "<leader>ghs",
                            "<cmd>Gitsigns stage_hunk<CR>",
                            desc = "stage hunk",
                            mode = "n"
                        },
                        {
                            "<leader>ghr",
                            "<cmd>Gitsigns reset_hunk<CR>",
                            desc = "reset hunk",
                            mode = "n"
                        },
                        {
                            "<leader>ghu",
                            function()
                                gs.undo_stage_hunk()
                            end,
                            desc = "undo stage hunk",
                            mode = "n"
                        },

                        { "<leader>gc", group = "copy" },
                        {
                            "<leader>gcf",
                            "<cmd>GitBlameCopyFileURL<cr>",
                            desc = "copy file URL",
                            mode = "n"
                        },
                        {
                            "<leader>gcc",
                            "<cmd>GitBlameCopyCommitURL<cr>",
                            desc = "copy commit URL",
                            mode = "n"
                        },

                    })
                end,
            })
        end
    },

    -- inline git blame
    {
        "f-person/git-blame.nvim",
        opts = {
            delay = 0,
            clipboard_register = "*",
            highlight_group = "NonText",
            date_format = "%d-%m-%Y",
            virtual_text_column = 70,
        },
        config = function(_, opts)
            require("gitblame").setup(opts)
        end,
    },

    {
        "sindrets/diffview.nvim",
        opts = {
            enhanced_diff_hl = false
        }
    }
}

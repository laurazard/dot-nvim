return {
    {
        'nvim-orgmode/orgmode',
        event = 'VeryLazy',
        ft = { 'org' },
        config = function()
            -- Setup orgmode
            require('orgmode').setup({
                org_agenda_files = '~/orgfiles/**/*',
                org_default_notes_file = '~/orgfiles/refile.org',

                org_todo_keywords = { 'TODO(t)', 'DOING(o@/!)', 'WAIT(w@/!)', '|', 'DONE(d)' },
                mappings = {
                    org_return_uses_meta_return = true
                }

                -- mappings = {
                --     org_agenda_clock_in = "<leader>ci"
                -- },
                -- open in float
                -- win_split_mode = function(name)
                --     -- Make sure it's not a scratch buffer by passing false as 2nd argument
                --     local bufnr = vim.api.nvim_create_buf(false, false)
                --     --- Setting buffer name is required
                --     vim.api.nvim_buf_set_name(bufnr, name)
                --
                --     local fill = 0.8
                --     local width = math.floor((vim.o.columns * fill))
                --     local height = math.floor((vim.o.lines * fill))
                --     local row = math.floor((((vim.o.lines - height) / 2) - 1))
                --     local col = math.floor(((vim.o.columns - width) / 2))
                --
                --     vim.api.nvim_open_win(bufnr, true, {
                --         relative = "editor",
                --         width = width,
                --         height = height,
                --         row = row,
                --         col = col,
                --         style = "minimal",
                --         border = "rounded"
                --     })
                -- end
            })

            -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
            -- add ~org~ to ignore_install
            -- require('nvim-treesitter.configs').setup({
            --   ensure_installed = 'all',
            --   ignore_install = { 'org' },
            -- })
        end,
    },
    {
        'akinsho/org-bullets.nvim',
        config = function()
            require('org-bullets').setup()
        end
    },
    {
        "nvim-orgmode/telescope-orgmode.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-orgmode/orgmode",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension("orgmode")
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'org',
                group = vim.api.nvim_create_augroup('orgmode_telescope_nvim', { clear = true }),
                callback = function()
                    vim.keymap.set('n', '<leader>or', require('telescope').extensions.orgmode.refile_heading)
                end,
            })

            vim.keymap.set("n", "<leader>or", require("telescope").extensions.orgmode.refile_heading)
            vim.keymap.set("n", "<leader>oh", require("telescope").extensions.orgmode.search_headings)
            vim.keymap.set("n", "<leader>oil", require("telescope").extensions.orgmode.insert_link)
        end,
    },
    {
        "danilshvalov/org-modern.nvim",
        dependencies = {
            "nvim-orgmode/orgmode"
        },
        config = function()
            local Menu = require("org-modern.menu")
            require("orgmode").setup({
                ui = {
                    menu = {
                        handler = function(data)
                            Menu:new({
                                window = {
                                    margin = { 1, 0, 1, 0 },
                                    padding = { 0, 1, 0, 1 },
                                    title_pos = "center",
                                    border = "single",
                                    zindex = 1000,
                                },
                                icons = {
                                    separator = "➜",
                                },
                            }):open(data)
                        end,
                    },
                },
            })
        end
    },
    {
        "chipsenkbeil/org-roam.nvim",
        dependencies = { { "nvim-orgmode/orgmode", }, },
        config = function()
            require("org-roam").setup({
                directory = "~/orgfiles",
                bindings = { prefix = "<leader>r", },
            })
        end
    }
}

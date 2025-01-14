return {
    -- better buffer delete (without messing up windows)
    -- and events for buffer delete
    {
        "famiu/bufdelete.nvim",
    },

    -- manager for persistent undo
    {
        "mbbill/undotree",
        event = { "BufReadPre", "BufNewFile" },
    },

    -- component library
    {
        "MunifTanjim/nui.nvim",
        lazy = true,
    },

    {
        "folke/persistence.nvim",
        -- this will only start session saving when an actual file was opened
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            -- add any custom options here
        }
    },

    { "christoomey/vim-tmux-navigator" },

    -- assortment of utils, using this for the
    -- statuscolumn niceties and for profiling
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = false },
            dashboard = { enabled = false },
            indent = { enabled = false },
            input = { enabled = false },
            notifier = { enabled = false },
            quickfile = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = { enabled = true },
            words = { enabled = false },
            profiler = {}
        },
    }
}

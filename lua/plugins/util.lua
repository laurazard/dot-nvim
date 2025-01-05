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
}

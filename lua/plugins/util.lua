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

  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    }
  },

  -- use C-j, C-k, etc. to navigate to tmux panes from neovim
  { "christoomey/vim-tmux-navigator" },
}

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
    -- this will only start session saving when an actual file was opened
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- add any custom options here
    }
  },

  -- bookmarks for code!
  {
    "ThePrimeagen/harpoon",
    event = { "BufReadPre", "BufNewFile" },
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup({})

      -- basic telescope configuration
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        }):find()
      end

      vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
        { desc = "Open harpoon window" })
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
      vim.keymap.set("n", "<leader>hd", function() harpoon:list():remove() end)
    end
  },

  -- use C-j, C-k, etc. to navigate to tmux panes from neovim
  { "christoomey/vim-tmux-navigator" },
}

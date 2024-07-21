-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "TMUX Down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "TMUX Up" })
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "TMUX Left" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "TMUX Right" })

local telescope_ignore_patterns = {
  {},
  {
    "[^a-z]vendor[^a-z]",
    "vendor[^a-z]",
  },
  {
    "[^a-z]test[^a-z]",
    "Test[^a-z]",
  },
  {
    "[^a-z]test[^a-z]",
    "[^a-z]vendor[^a-z]",
    "Test[^a-z]",
    "vendor[^a-z]",
  },
}
map("n", "<C-v>", function()
  local current_index = vim.g.telescope_ignore_index or 1
  require("telescope.config").set_defaults({
    file_ignore_patterns = telescope_ignore_patterns[current_index + 1],
  })
  local ignored_patterns = table.concat(telescope_ignore_patterns[current_index + 1], " ")
  require("notify")("Toggle telescope ignore patterns: " .. ignored_patterns)
  local next_index = ((current_index + 1) % 4)
  vim.g.telescope_ignore_index = next_index
end, { desc = "Toggle telescope ignore patterns" })

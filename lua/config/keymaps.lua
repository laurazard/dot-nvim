map = vim.keymap.set

-- Tmux keybindings
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "TMUX Down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "TMUX Up" })
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "TMUX Left" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "TMUX Right" })

-- navigate buffers with shift+H, shift+L
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- custom (hide vendor/test) ignore patterns
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

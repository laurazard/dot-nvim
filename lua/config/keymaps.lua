map = vim.keymap.set

-- navigate buffers with shift+H, shift+L
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

map("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>")
map("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>")
map("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>")
map("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>")

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

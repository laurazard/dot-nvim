vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  desc = 'return cursor to where it was last time closing the file',
  pattern = '*',
  command = 'silent! normal! g`"zv',
})

--Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_augroup("dashboard_on_empty", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "BDeletePost*",
  group = "dashboard_on_empty",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(bufnr)

    if name == "" then
      vim.cmd("Dashboard")
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_augroup("close_with_q", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "close_with_q",
  pattern = {
    "PlenaryTestPopup",
    "grug-far",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
    "gitsigns.blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_augroup("resize_splits", { clear = true })
vim.api.nvim_create_autocmd({ "vimresized" }, {
  group = "resize_splits",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- close neo-tree, trouble before saving session to persistence.nvim
vim.api.nvim_create_augroup("clear-ui-before-save", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "PersistenceSavePre",
  group = "clear-ui-before-save",
  callback = function()
    vim.cmd("Trouble diagnostics close")
    vim.cmd("Neotree close")
    require("dapui").close()
  end,
})

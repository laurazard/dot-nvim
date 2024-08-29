-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.keymaps")
require("config.autocmds")

-- use unnamed clipboard ('*'): required for clipboard
-- syncing to work properly with xquartz, for some reason
vim.opt.clipboard = "unnamed"
vim.wo.number = true
vim.wo.cursorline = true

vim.opt.tabstop = 4     -- Always 8 (see :h tabstop)
vim.opt.softtabstop = 4 -- What you expecting
vim.opt.shiftwidth = 4  -- What you expecting
vim.opt.expandtab = true
vim.opt.undofile = true

vim.opt.fillchars = {
	horiz     = '━',
	horizup   = '┻',
	horizdown = '┳',
	vert      = '┃',
	vertleft  = '┫',
	vertright = '┣',
	verthoriz = '╋',
	diff      = '╱',
}

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- use unnamed clipboard ('*'): required for clipboard
-- syncing to work properly with xquartz, for some reason
vim.opt.clipboard = 'unnamed'

-- setup snacks.profiler
if vim.env.PROF then
    -- example for lazy.nvim
    -- change this to the correct path for your plugin manager
    local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
    vim.opt.rtp:append(snacks)
    require("snacks.profiler").startup({
        startup = {
            event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
            -- event = "UIEnter",
            -- event = "VeryLazy",
        },
    })
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("config.filetypes")

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
vim.opt.ignorecase = true

vim.opt.fillchars = {
    horiz     = '_',
    horizup   = '_',
    horizdown = '_',
    vert      = '▕',
    vertleft  = '▕',
    vertright = '▕',
    verthoriz = '▕',
    diff      = '╱',
}

-- vim.opt.fillchars = {
--     horiz     = '━',
--     horizup   = '┻',
--     horizdown = '┳',
--     vert      = '┃',
--     vertleft  = '┫',
--     vertright = '┣',
--     verthoriz = '╋',
--     diff      = '╱',
-- }

-- { "🭽", "▔", "🭾", "▕", "🭿", "", "🭼", "▏" }

vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'

vim.opt.splitkeep = "screen"

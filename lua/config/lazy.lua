-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.lazy_events_config = {
    simple = {
        LazyFile = { "BufReadPost", "BufNewFile", "BufWritePre" },
    }
}

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- import your plugins
        { "bwpge/lazy-events.nvim", import = "lazy-events.import", lazy = false },
        -- { import = "plugins.editor" },
        -- { import = "plugins.code" },
        { import = "plugins" },
    },
    defaults = {
        lazy = false,
    },
    -- automatically check for plugin updates
    checker = { enabled = true, notify = false },
    throttle = {
        enabled = true, -- not enabled by default
        -- max 2 ops every 5 seconds
        rate = 2,
        duration = 5 * 1000, -- in ms
    },
})

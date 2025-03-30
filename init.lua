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

DUMP = function(o)
    if type(o) == 'table' then
        local s = '{\n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. DUMP(v) .. ','
        end
        return s .. '}\n'
    else
        return tostring(o)
    end
end

package.path = './lua/lib/?.lua;' .. package.path

ADD_CMD = vim.api.nvim_create_user_command

ADD_CMD("PrintAllWinOptions", function()
    local win_number = vim.api.nvim_get_current_win()
    local v = vim.wo[win_number]
    local all_options = vim.api.nvim_get_all_options_info()
    local result = ''
    for key, val in pairs(all_options) do
        if val.global_local == false and val.scope == 'win' then
            result = result ..
                '\n' .. key .. '=' .. tostring(v[key] or '<not set>')
        end
    end
    print(result)
end, {})

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("config.filetypes")
require("config.lsp")

-- use unnamed clipboard ('*'): required for clipboard
-- syncing to work properly with xquartz, for some reason
vim.opt.clipboard = "unnamed"
vim.wo.number = true

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

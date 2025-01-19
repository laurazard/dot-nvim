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
        require("neo-tree")
        require("trouble")
        require("neotest")
        vim.cmd("Trouble diagnostics close")
        vim.cmd("Trouble lsp_definitions close")
        vim.cmd("Trouble lsp_references close")
        vim.cmd("Trouble lsp_implementations close")
        vim.cmd("Trouble symbols close")
        vim.cmd("Trouble loclist close")
        vim.cmd("Neotree close")
        vim.cmd("Neotest summary close")
        require("dapui").close()
    end,
})

-- style colorscheme of neotest output
vim.api.nvim_create_augroup("style-neotest", { clear = true })
vim.api.nvim_create_autocmd({ "WinNew", "WinLeave", "WinEnter", "BufAdd", "WinResized" }, {
    group = "style-neotest",
    callback = function(event)
        -- dump = function(o)
        --     if type(o) == 'table' then
        --         local s = '{ '
        --         for k, v in pairs(o) do
        --             if type(k) ~= 'number' then k = '"' .. k .. '"' end
        --             s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        --         end
        --         return s .. '} '
        --     else
        --         return tostring(o)
        --     end
        -- end

        vim.api.nvim_set_hl(2, "Normal", { link = "TroubleNormalNC" })
        vim.api.nvim_set_hl(2, "EndOfBuffer", { link = "MeowBork" })
        vim.api.nvim_set_hl(2, "EdgyWinBar", { link = "MeowBork" })
        vim.api.nvim_set_hl(3, "TroubleNormalNC", { link = "TroubleAlt" })
        vim.api.nvim_set_hl(3, "TroubleNormal", { link = "TroubleAlt" })

        for _, window in pairs(vim.fn.getwininfo()) do
            local ft
            pcall(function()
                vim.api.nvim_win_call(window.winid, function()
                    ft = vim.bo.filetype
                end)
            end)
            -- require("notify")(dump(vim.w[window.winid]))
            if vim.w[window.winid].trouble ~= nil and vim.w[window.winid].trouble.type == "split" then
                -- require("notify")(dump(vim.w[window.winid].trouble))
                vim.api.nvim_win_set_hl_ns(window.winid, 3)
            end

            if ft == "neotest-summary" then
                vim.api.nvim_win_set_hl_ns(window.winid, 2)
            end
        end
    end,
})

-- need this to be able to automatically comment tla files 
vim.api.nvim_create_augroup("comment_tla", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "comment_tla",
    pattern = {
        "tla",
    },
    callback = function()
        vim.bo["commentstring"] = "\\* %s"
    end,
})

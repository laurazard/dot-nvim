return {
    -- code parser/highlighter/textobjects
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old
        build = ":TSUpdate",
        opts = function(_, opts)
            -- A list of parser names, or "all" (the listed parsers MUST always be installed)
            local ensure_installed = {
                "vimdoc",
                "gitcommit",
                "html",
                "javascript",
                "json",
                "markdown",
                "markdown_inline",
                "query",
                "regex",
                "ssh_config",
                "tsx",
                "typescript",
                "vim",
            }
            for _, item in ipairs(ensure_installed) do
                table.insert(opts.ensure_installed, item)
            end

            -- Install parsers synchronously (only applied to `ensure_installed`)
            opts.sync_install = false

            ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
            -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

            opts.highlight = {
                enable = true,

                ---@diagnostic disable: unused-local
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    ---@diagnostic disable: undefined-field
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            }

            return opts
        end,
        config = function(_, opts)
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
            -- require("notify")(dump(opts.ensure_installed))

            for ft, parser in pairs(opts.extra_mappings) do
                -- require("notify")(ft .. " " .. parser)
                vim.treesitter.language.register(parser, ft)
            end
            opts.extra_mappings = nil

            require 'nvim-treesitter.configs'.setup(opts)
        end
    },

    {
        "ggandor/leap.nvim",
        config = function()
            require('leap').create_default_mappings()
            vim.keymap.set('n', 's', '<Plug>(leap)')
            vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
            vim.keymap.set({ 'x', 'o' }, 's', '<Plug>(leap-forward)')
            vim.keymap.set({ 'x', 'o' }, 'S', '<Plug>(leap-backward)')
        end
    },
}

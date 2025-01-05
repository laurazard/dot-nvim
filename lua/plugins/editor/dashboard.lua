return {
    -- start dashboard
    {
        "nvimdev/dashboard-nvim",
        event = 'VimEnter',
        opts = function(_, opts)
            -- customize the dashboard header
            local space_above = vim.fn.max({ 3, vim.fn.floor(vim.fn.winheight(0) * 0.1) })
            local space_below = 3
            local header = {}

            local catcoffee = {
                "             ^~:                    :!!^                  ",
                "            :?!!7?7~^^^....:...:!77?!!7~                  ",
                "            ^?~!!!!!!!:    :!77!!!!!!!?:                  ",
                "            :!~!!!!~:        .^~!!!!!~?:                  ",
                "            !7!!~:.             .:^~!!7?                  ",
                "            7:.  .  .         . .    ..^:                 ",
                "           :.    ....    Y!    ..       ^.                ",
                "           ~  .:^^:      ::    .:^^:.    ~                ",
                "          :.    ..               ..      .:               ",
                "          ~                               ^.              ",
                "       ...~                                ! ..           ",
                "      !.  ^      .              ..         ^   ~          ",
                "      ~..:~:-.!777!!!^       .~!~!!7!:  .~ .^.:7 .....    ",
                "      :.     ...:!777?^ __. .7!!77~~~~:.      ::      .:  ",
                "       ^                        .             ~  ....   ^ ",
                "       :.                                    ^:      ^  :.",
                "        ~   ^  :~ :~ ^.:.. ..: :. :.~ :.::   ^     ^   ^  ",
                "        :. :.  ~^  ^ ^:..^ ~~ .^  ~.7:^^ ~  :.   .:   ^   ",
                "         ^  ^..!.! ^ :.  ^^:^  ^  ^..^!.^^  ~   :.  .^    ",
                "         ~                                  ^ .:   ..     ",
                "          ^            .      .            ~:    ..       ",
                "          ~           ....  ....           ~ .:.          ",
                "          :.          .........           .!:.            ",
                "           ^            ......            ^:              ",
                "           ~              ..              ~               ",
                "           ^.                           . ^               ",
                "             .                         .                  ",
                "             .. _ . .. _ .: _ .. _ . ..                   ",
            }

            for i = 0, space_above do
                table.insert(header, "")
            end
            for i = 1, #catcoffee do
                table.insert(header, catcoffee[i])
            end
            for i = 0, space_below do
                table.insert(header, "")
            end
            opts.config = {
                header = header,
                shortcut = {
                    { action = "lua require('telescope.builtin').find_files()", desc = " Find File", icon = " ", key = "f" },
                    { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
                    { action = "lua require('telescope.builtin').live_grep()", desc = " Find Text", icon = " ", key = "/" },
                    { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
                    { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
                    { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit", icon = " ", key = "q" },
                },
            }
            return opts
        end,
    },

}

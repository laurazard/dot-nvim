return {
    -- better buffer delete (without messing up windows)
    -- and events for buffer delete
    {
        "famiu/bufdelete.nvim",
    },

    -- manager for persistent undo
    {
        "mbbill/undotree",
        event = { "BufReadPre", "BufNewFile" },
    },

    -- component library
    {
        "MunifTanjim/nui.nvim",
        lazy = true,
    },

    {
        "folke/persistence.nvim",
        -- this will only start session saving when an actual file was opened
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            -- add any custom options here
        }
    },

    {
        'alexghergh/nvim-tmux-navigation',
        config = function()
            require 'nvim-tmux-navigation'.setup {
                disable_when_zoomed = true, -- defaults to false
                keybindings = {
                    left = "<C-h>",
                    down = "<C-j>",
                    up = "<C-k>",
                    right = "<C-l>",
                    last_active = "<C-\\>",
                    next = "<C-Space>",
                }
            }
        end
    },

    -- assortment of utils, using this for the
    -- statuscolumn niceties and for profiling
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = false },
            dashboard = {
                enabled = true,
                preset = {
                    header = "             ^~:                    :!!^                  \n" ..
                        "            :?!!7?7~^^^....:...:!77?!!7~                  \n" ..
                        "            ^?~!!!!!!!:    :!77!!!!!!!?:                  \n" ..
                        "            :!~!!!!~:        .^~!!!!!~?:                  \n" ..
                        "            !7!!~:.             .:^~!!7?                  \n" ..
                        "            7:.  .  .         . .    ..^:                 \n" ..
                        "           :.    ....    Y!    ..       ^.                \n" ..
                        "           ~  .:^^:      ::    .:^^:.    ~                \n" ..
                        "          :.    ..               ..      .:               \n" ..
                        "          ~                               ^.              \n" ..
                        "       ...~                                ! ..           \n" ..
                        "      !.  ^      .              ..         ^   ~          \n" ..
                        "      ~..:~:-.!777!!!^       .~!~!!7!:  .~ .^.:7 .....    \n" ..
                        "      :.     ...:!777?^ __. .7!!77~~~~:.      ::      .:  \n" ..
                        "       ^                        .             ~  ....   ^ \n" ..
                        "       :.                                    ^:      ^  :.\n" ..
                        "        ~   ^  :~ :~ ^.:.. ..: :. :.~ :.::   ^     ^   ^  \n" ..
                        "        :. :.  ~^  ^ ^:..^ ~~ .^  ~.7:^^ ~  :.   .:   ^   \n" ..
                        "         ^  ^..!.! ^ :.  ^^:^  ^  ^..^!.^^  ~   :.  .^    \n" ..
                        "         ~                                  ^ .:   ..     \n" ..
                        "          ^            .      .            ~:    ..       \n" ..
                        "          ~           ....  ....           ~ .:.          \n" ..
                        "          :.          .........           .!:.            \n" ..
                        "           ^            ......            ^:              \n" ..
                        "           ~              ..              ~               \n" ..
                        "           ^.                           . ^               \n" ..
                        "             .. _ . .. _ .: _ .. _ . ..                   ",
                },
                sections = {
                    { section = "header" },
                    { section = "keys",  gap = 1, padding = 1 },
                    {
                        pane = 2,
                        padding = 1,
                        text = {
                            "       ██████╗ ██╗████████╗██╗  ██╗██╗   ██╗██████╗ \n" ..
                            "      ██╔════╝ ██║╚══██╔══╝██║  ██║██║   ██║██╔══██╗\n" ..
                            "      ██║  ███╗██║   ██║   ███████║██║   ██║██████╔╝\n" ..
                            "      ██║   ██║██║   ██║   ██╔══██║██║   ██║██╔══██╗\n" ..
                            "      ╚██████╔╝██║   ██║   ██║  ██║╚██████╔╝██████╔╝\n" ..
                            "       ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ",
                            hl = 'SnacksDashboardTitle'
                        },
                    },
                    {
                        pane = 2,
                        icon = " ",
                        desc = "Browse Repo",
                        padding = 1,
                        key = "b",
                        action = function()
                            Snacks.gitbrowse()
                        end,
                    },
                    function()
                        local in_git = Snacks.git.get_root() ~= nil
                        local cmds = {
                            {
                                title = "Notifications",
                                cmd = "gh notify -s -a -n5",
                                action = function()
                                    vim.ui.open("https://github.com/notifications")
                                end,
                                key = "n",
                                icon = " ",
                                height = 10,
                                enabled = true,
                            },
                            {
                                title = "Open Issues",
                                cmd = "gh issue list -L 3",
                                key = "i",
                                action = function()
                                    vim.fn.jobstart("gh issue list --web", { detach = true })
                                end,
                                icon = " ",
                                height = 7,
                            },
                            {
                                icon = " ",
                                title = "Open PRs",
                                cmd = "gh pr list -L 3",
                                key = "P",
                                action = function()
                                    vim.fn.jobstart("gh pr list --web", { detach = true })
                                end,
                                height = 7,
                            },
                            {
                                icon = " ",
                                title = "Git Status",
                                cmd = "git --no-pager diff --stat -B -M -C",
                                height = 10,
                            },
                        }
                        return vim.tbl_map(function(cmd)
                            return vim.tbl_extend("force", {
                                pane = 2,
                                section = "terminal",
                                enabled = in_git,
                                padding = 1,
                                ttl = 5 * 60,
                                indent = 3,
                            }, cmd)
                        end, cmds)
                    end,
                    { section = "startup" },
                },
            },
            indent = { enabled = false },
            input = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = { enabled = true },
            words = { enabled = false },
            profiler = {}
        },
    }
}

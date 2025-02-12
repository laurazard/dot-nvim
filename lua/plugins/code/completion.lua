return {
    {
        "xzbdmw/colorful-menu.nvim",
        config = function()
            -- You don't need to set these options.
            require("colorful-menu").setup({
                ls = {
                    gopls = {
                        -- When true, label for field and variable will format like "foo: Foo"
                        -- instead of go's original syntax "foo Foo".
                        add_colon_before_type = false,
                    },
                    ["rust-analyzer"] = {
                        -- Such as (as Iterator), (use std::io).
                        extra_info_hl = "@comment",
                    },

                    -- If we should try to highlight "not supported" languages
                    fallback = true,
                },
                -- If the built-in logic fails to find a suitable highlight group,
                -- this highlight is applied to the label.
                fallback_highlight = "@variable",
                -- If provided, the plugin truncates the final displayed text to
                -- this width (measured in display cells). Any highlights that extend
                -- beyond the truncation point are ignored. Default 60.
                max_width = 60,
            })
        end,
    },

    {
        'saghen/blink.cmp',
        Event = "LazyFile",
        dependencies = {
            -- optional: provides snippets for the snippet source
            'rafamadriz/friendly-snippets',
        },

        -- use a release tag to download pre-built binaries
        version = '*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            snippets = {
                preset = 'default',
            },

            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- See the full "keymap" documentation for information on defining your own keymap.
            keymap = {
                preset = 'enter',

                ['<Tab>'] = {
                    'select_next',
                    'fallback'
                },
                ['<S-Tab>'] = {
                    'select_prev',
                    'fallback'
                },
            },

            completion = {
                ghost_text = {
                    enabled = true
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                },
                list = {
                    selection = {
                        preselect = function(ctx)
                            return ctx.mode ~= 'cmdline'
                        end,
                        auto_insert = true,
                    },
                },
                menu = {
                    direction_priority = {
                        "n"
                    },
                    -- auto_show = function(ctx) return ctx.mode ~= 'cmdline' end,
                    draw = {
                        -- disabled since using colorful-menu
                        -- treesitter = { 'lsp' },
                        components = {
                            kind_icon = {
                                ellipsis = false,
                                text = function(ctx)
                                    local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                                    return kind_icon
                                end,
                            },
                            label = {
                                width = { fill = true, max = 60 },
                            },
                        },
                        columns = { { "kind_icon", gap = 1 }, { "label", "label_description", gap = 1 } },
                    },
                    auto_show = true,
                },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono',
                kind_icons = {
                    Text = "󰉿",
                    Method = "󰆧",
                    Function = "󰊕",
                    Constructor = "",
                    Field = " ",
                    Variable = "󰀫",
                    Class = "󰠱",
                    Interface = "",
                    Module = "",
                    Property = "󰜢",
                    Unit = "󰑭",
                    Value = "󰎠",
                    Enum = "",
                    Keyword = "󰌋",
                    Snippet = "",
                    Color = "󰏘",
                    File = "󰈙",
                    Reference = "",
                    Folder = "󰉋",
                    EnumMember = "",
                    Constant = "󰏿",
                    Struct = "",
                    Event = "",
                    Operator = "󰆕",
                    TypeParameter = " ",
                    Misc = " ",
                }
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                -- remember to enable your providers here
                default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'orgmode' },
                providers = {
                    orgmode = {
                        name = 'Orgmode',
                        module = 'orgmode.org.autocompletion.blink',
                    },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                }
            }
        },
        config = function(_, opts)
            opts.completion.menu.draw.components.label.text = require("colorful-menu").blink_components_text
            opts.completion.menu.draw.components.label.highlight = require("colorful-menu").blink_components_highlight

            require("blink.cmp").setup(opts)
        end,
        keys = {
            {
                "≥", -- Alt-.
                mode = { "i" },
                function()
                    require("blink.cmp").show()
                end,
            },
        },
    }
}

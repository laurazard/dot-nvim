return {
    -- colorscheme
    {
        "rebelot/kanagawa.nvim",
        as = "kanagawa",
        config = function()
            require("kanagawa").setup({
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none",
                            },
                        },
                    },
                },
                overrides = function(colors)
                    local theme = colors.theme
                    local makeDiagnosticColor = function(color)
                        local c = require("kanagawa.lib.color")
                        return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
                    end
                    return {
                        -- popup menu
                        Pmenu                      = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
                        PmenuSel                   = { fg = "none", bg = theme.ui.bg_p2 },
                        PmenuSbar                  = { bg = theme.ui.bg_m1 },
                        PmenuThumb                 = { bg = theme.ui.bg_p2 },

                        -- telescope ui modern
                        TelescopeTitle             = { fg = theme.ui.special, bold = true },
                        TelescopePromptNormal      = { bg = theme.ui.bg_p1 },
                        TelescopePromptBorder      = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                        TelescopeResultsNormal     = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                        TelescopeResultsBorder     = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                        TelescopePreviewNormal     = { bg = theme.ui.bg_dim },
                        TelescopePreviewBorder     = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

                        -- transparent floating windows
                        NormalFloat                = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                        -- NormalFloat                = { bg = "none" },
                        FloatBorder                = { bg = "none" },
                        FloatTitle                 = { bg = "none" },
                        EdgyNormal                 = { fg = "none", bg = theme.ui.bg },
                        EdgyNormalNC               = { fg = "none", bg = theme.ui.bg },

                        LspLens                    = { fg = theme.ui.nontext, bg = theme.ui.bg },

                        -- LeapBackdrop = { bg = theme.syn.parameter },
                        -- LeapMatch = { fg = theme.syn.parameter, bg = theme.syn.parameter },
                        LeapLabel                  = { fg = theme.ui.bg_m3, bg = theme.syn.parameter },

                        -- which-key
                        -- WhichKeyNormal             = { bg = theme.ui.bg_dim },
                        WhichKeyNormal             = { bg = theme.ui.bg_p1 },
                        -- which-key hydra border
                        -- WhichKeyBorder             = { bg = theme.ui.bg_dim, fg = theme.syn.parameter },
                        WhichKeyBorder             = { bg = "none", fg = theme.ui.bg_dim },
                        -- WhichKeyTitle              = { bg = theme.ui.bg_dim },
                        WhichKeyTitle              = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

                        -- Save an hlgroup with dark background and dimmed foreground
                        -- so that you can use it where your still want darker windows.
                        -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
                        NormalDark                 = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

                        -- Popular plugins that open floats will link to NormalFloat by default;
                        -- set their background accordingly if you wish to keep them dark and borderless
                        LazyNormal                 = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        MasonNormal                = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

                        CursorLine                 = { bg = theme.ui.bg_p1 },

                        -- highlight symbol under cursor
                        IlluminatedWordText        = { bg = theme.ui.bg_p1, bold = true },

                        -- diagnostic message background
                        DiagnosticVirtualTextInfo  = makeDiagnosticColor(theme.diag.info),
                        DiagnosticVirtualTextWarn  = makeDiagnosticColor(theme.diag.warning),
                        DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),

                        TinyInlineDiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
                        TinyInlineDiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
                        TinyInlineDiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),

                        TroubleNormalNC            = { bg = theme.ui.bg_dim },
                        TroubleNormal              = { bg = theme.ui.bg_dim },
                        TroubleAlt                 = { bg = theme.ui.bg_m3 },

                        MeowBork                   = { fg = theme.ui.bg_dim, bg = theme.ui.bg_dim },
                    }
                end,
            })
            vim.api.nvim_command("colorscheme kanagawa")
        end
    },
}

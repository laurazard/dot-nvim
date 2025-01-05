return {
    -- base debug-adapter plugin
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        dependencies = { "leoluz/nvim-dap-go", "theHamsta/nvim-dap-virtual-text" },
        keys = {
            {
                "<leader>db",
                function()
                    require 'dap'.toggle_breakpoint()
                end,
                desc = "toggle breakpoint"
            },
            {
                "<leader>dc",
                function()
                    require 'dap'.continue()
                end,
                desc = "start/continue debug session"
            },
            {
                "<leader>dd",
                function()
                    require 'dap'.disconnect()
                end,
                desc = "stop debug session"
            },
            {
                "<leader>ds",
                function()
                    require 'dap'.step_over()
                end,
                desc = "debug - step over"
            },
            {
                "<leader>di",
                function()
                    require 'dap'.step_into()
                end,
                desc = "debug - step over"
            },
            {
                "<leader>du",
                function()
                    require("dapui").toggle()
                end,
                desc = "toggle debug ui"
            },
        },
        config = function()
            require('dap-go').setup()
            require("nvim-dap-virtual-text").setup({})
        end
    },

    -- golang dap-adapter
    {
        "leoluz/nvim-dap-go",
        lazy = true,
        dependencies = { "mfussenegger/nvim-dap" },
        keys = {
            {
                "<leader>dt",
                function()
                    require('dap-go').debug_test()
                end,
                desc = "debug - nearest test"
            },
        },
        config = function()
            require("dap-go").setup({
                dap_configurations = {
                    -- {
                    --   type = "go",
                    --   name = "Debug (Build Flags & Arguments)",
                    --   request = "launch",
                    --   program = "${file}",
                    --   args = require("dap-go").get_arguments,
                    --   buildFlags = require("dap-go").get_build_flags,
                    -- },
                    {
                        name = "attach dit",
                        type = "go",
                        request = "launch",
                        program = "./cmd/docker",
                        args = require("dap-go").get_arguments,
                    }
                },
            })
        end
    },

    -- dap ui
    {
        "theHamsta/nvim-dap-virtual-text"
    },

    -- debug ui
    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", "leoluz/nvim-dap-go" },
        config = function()
            require("dapui").setup()
        end
    }
}

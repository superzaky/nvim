return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "mfussenegger/nvim-dap-python",
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local dap = require("dap")
        local dap_python = require("dap-python")

        -- Detect if we are on Windows
        if vim.fn.has("win32") == 1 then
            -- Point directly to your trusted system Python
            local sys_python = "C:/Users/z.huraibi/AppData/Local/Programs/Python/Python313/python.exe"
            -- Use the 'python' adapter type but point it to your system install
            dap_python.setup(sys_python)
        else
            -- Linux setup remains the same
            local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
            dap_python.setup(mason_path)
        end
        -- 1. Point to the debugpy path installed by Mason
        -- Adjust this path if your Mason folder is elsewhere
        -- local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
        -- local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
        -- dap_python.setup(path)
        dap_python.setup(mason_path)

        -- 2. Basic Keymaps for Debugging
        vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = "Debug: Continue" })
        -- for some reason F5 moves the cursor only downwards in qterminal and does not start the debugger for some reason, so that is why we comment the line below
        -- vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = "Debug: Start/Continue" })
        vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = "Debug: Step Over" })
        vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = "Debug: Step Into" })
        vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })

        -- 3. UI Setup (Optional but very helpful)
        local dapui = require("dapui")
        dapui.setup()
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

        -- Automatic configuration for python
        dap.configurations.python = {
            {
                type = 'python',
                request = 'launch',
                name = "Launch file",
                program = "${file}", -- This tells it to run the current file
                pythonPath = function()
                    -- This finds the python path automatically
                    return 'python3'
                end,
            },
        }
    end,
}

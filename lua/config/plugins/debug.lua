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
        local python_path = ""

        -- 1. Setup Python Path based on OS
        if vim.fn.has("win32") == 1 then
            python_path = "C:/Users/z.huraibi/AppData/Local/Programs/Python/Python313/python.exe"
        else
            python_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
        end
        
        dap_python.setup(python_path)

        -- 2. Debugging Keymaps
        vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = "Debug: Continue" })
        -- for some reason F5 moves the cursor only downwards in qterminal and does not start the debugger for some reason, so that is why we comment the line below
        -- vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = "Debug: Start/Continue" })
        vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = "Debug: Step Over" })
        vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = "Debug: Step Into" })
        vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })

        -- 3. UI Setup
        local dapui = require("dapui")
        dapui.setup()
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

        -- 4. Custom Python Configurations
        dap.configurations.python = {
            {
                -- Standard Launch (Works on Linux or Windows)
                type = 'python',
                request = 'launch',
                name = "Launch file",
                program = "${file}",
                pythonPath = python_path,
            },
            {
                -- Corporate Attach (For your PowerShell manual launch)
                type = 'python',
                request = 'attach',
                name = "Attach (Windows Port 5678)",
                connect = {
                    host = '127.0.0.1',
                    port = 5678,
                },
                -- This helps Neovim find the source code on your machine
                pathMappings = {
                    {
                        localRoot = vim.fn.getcwd(),
                        remoteRoot = ".",
                    },
                },
            },
        }
    end,
}

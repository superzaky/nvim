return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "mfussenegger/nvim-dap-python",
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        local dap_python = require("dap-python")

        -- 1. Setup Python Path based on OS
        if vim.fn.has("win32") == 1 then
            python_path = "C:/Users/z.huraibi/AppData/Local/Programs/Python/Python313/python.exe"
        else
            python_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
        end
        
        dap_python.setup(python_path)

        -- 2. Setup .NET Adapter (netcoredbg)
        dap.adapters.coreclr = {
            type = 'executable',
            -- Mason installs it to a 'bin' folder usually, but check your Mason install
            --   command = vim.fn.stdpath("data") .. '/mason/bin/netcoredbg' .. (vim.fn.has("win32") == 1 and ".exe" or ""),
            command = 'C:/projects/netcoredbg/netcoredbg.exe',
            args = { '--interpreter=vscode' }
        }

        -- 3. Debugging Keymaps
        vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = "Debug: Continue" })
        vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = "Debug: Step Over" })
        vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = "Debug: Step Into" })
        vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
        
        -- REPL & Hover Keymaps
        vim.keymap.set('n', '<leader>dr', function() dap.repl.toggle() end, { desc = "Debug: Toggle REPL" })
        vim.keymap.set('n', '<leader>di', function() require("dap.ui.widgets").hover() end, { desc = "Debug: Hover Info" })
        vim.keymap.set('n', '<leader>de', function() require("dapui").eval() end, { desc = "Debug: Evaluate Under Cursor" })
        -- 4. UI Setup
        dapui.setup()
        
        -- 5. Automate Opening Windows on Exception
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end

        -- IMPORTANT: If the debugger stops on an exception, open the REPL automatically
        dap.listeners.after.event_stopped["dap_exception_info"] = function(_, body)
            if body.reason == "exception" then
                print("Exception caught! Opening REPL for inspection...")
                dap.repl.open()
            end
        end

        -- 5. Custom Python Configurations
        dap.configurations.python = {
            {
                type = 'python',
                request = 'launch',
                name = "Launch file",
                program = "${file}",
                pythonPath = python_path,
            },
            {
                -- Corporate Attach
                type = 'python',
                request = 'attach',
                name = "Attach (Windows Port 5678)",
                connect = {
                    host = '127.0.0.1',
                    port = 5678,
                },
                pathMappings = {
                    {
                        localRoot = vim.fn.getcwd(),
                        remoteRoot = ".",
                    },
                },
            },
        }
        -- 6. Custom .NET Configurations
        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "Launch - netcoredbg",
                request = "launch",
                program = function()
                    -- Ensure we are selecting the Debug DLL specifically
                    return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/net8.0/YOUR_APP_NAME_HERE.dll', 'file')
                end,
                cwd = "${workspaceFolder}",
                stopAtEntry = false,
                -- THE FIX FOR HANGFIRE WARNINGS:
                justMyCode = true,
                symbolOptions = {
                    loadAnySymbol = false, -- DO NOT load symbols for external libraries (Hangfire, etc.)
                    moduleFilter = {
                        mode = "include",
                        names = { "YOUR_APP_NAME_HERE" } -- ONLY load symbols for your actual project name
                    }
                },
                env = {
                    ASPNETCORE_ENVIRONMENT = "Development",
                    ASPNETCORE_URLS = "https://localhost:44320",
                },
            },
        }
    end,
}
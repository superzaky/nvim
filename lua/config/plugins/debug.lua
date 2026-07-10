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
        local python_path = ""
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
            command = "C:\\projects\\netcoredbg\\netcoredbg.exe",
            args = { '--interpreter=vscode' },
            options = {
                detached = false
            }
        }

        -- Helper function to Build and then Debug
        local function build_and_debug()
            local session = dap.session()
            -- If a debug session is already running, terminate it first
            -- This unlocks the DLL so 'dotnet build' can succeed
            if session then
                print("Terminating existing debug session...")
                dap.terminate(nil, nil, function()
                    -- We use the termination callback to ensure 
                    -- the process has fully exited before building
                    build_and_debug() 
                end)
                return
            end

            print("Building project...")
            vim.fn.jobstart("dotnet build", {
                on_exit = function(_, code)
                    if code == 0 then
                        print("Build successful! Starting debugger...")
                        dap.continue()
                    else
                        print("Build FAILED. Debugger aborted. (Is the app still running elsewhere?)")
                    end
                end
            })
        end

        -- 3. Debugging Keymaps
        vim.keymap.set('n', '<F5>', build_and_debug, { desc = "Debug: Build and Start/Restart" })
        
        vim.keymap.set('n', '<F4>', function()
            dap.terminate()
            dapui.close()
        end, { desc = "Debug: Stop and Close UI" })

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
        
        -- 5. Automate Opening/Closing Windows
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end

        local doc_listeners = dap.listeners.before
        doc_listeners.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        doc_listeners.event_exited["dapui_config"] = function()
            dapui.close()
        end

        -- 6. Custom Python Configurations
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
            }
        }

        -- 7. Custom .NET Configurations (Robust Windows Path Handling)
        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "Launch - netcoredbg",
                request = "launch",
                args = {}, 
                program = function()
                    local cwd = vim.fn.getcwd()
                    local function to_win(path)
                        return path:gsub("/", "\\")
                    end

                    local paths_to_check = {
                        cwd .. '\\YOUR_APP_NAME_HERE\\bin\\Debug\\net8.0\\YOUR_APP_NAME_HERE.dll',
                        cwd .. '\\bin\\Debug\\net8.0\\YOUR_APP_NAME_HERE.dll'
                    }

                    for _, p in ipairs(paths_to_check) do
                        local win_path = to_win(p)
                        if vim.fn.filereadable(win_path) == 1 then
                            return win_path
                        end
                    end

                    return to_win(vim.fn.input('Path to DLL: ', cwd .. '\\bin\\Debug\\net8.0\\', 'file'))
                end,
                cwd = function()
                    return vim.fn.getcwd():gsub("/", "\\")
                end,
                stopAtEntry = false,
                justMyCode = true,
                symbolOptions = {
                    searchMicrosoftSymbolServer = false,
                    searchNuGetOrgSymbolServer = false,
                    moduleFilter = {
                        mode = "loadAllButExcluded",
                        excludedModules = {}
                    }
                },
                env = function()
                    local cwd = vim.fn.getcwd()
                    local content_root = cwd

                    -- Smart layout processing logic to stop path double-appending loops
                    if not cwd:match("YOUR_APP_NAME_HERE$") then
                        content_root = cwd .. "\\YOUR_APP_NAME_HERE"
                    end

                    content_root = content_root:gsub("/", "\\")

                    return {
                        ASPNETCORE_ENVIRONMENT = "Development",
                        ASPNETCORE_URLS = "https://localhost:44320",
                        ASPNETCORE_CONTENTROOT = content_root,
                    }
                end,
            },
        }
    end,
}
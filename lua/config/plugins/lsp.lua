return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "nvim-telescope/telescope.nvim",
            "hrsh7th/cmp-nvim-lsp", -- Required for capabilities
        },

        config = function()
            -- 1. Initialize Mason
            require("mason").setup()

            local lspconfig = require("lspconfig")
            
            -- 2. Setup Capabilities (for Autocomplete support)
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- 3. Setup Mason-LSPConfig with Handlers
            -- This is the "Magic" part for Windows: it automatically links Mason and Lspconfig
            require("mason-lspconfig").setup({
                ensure_installed = { 
                    "lua_ls", 
                    "bashls", 
                    "omnisharp", 
                    "angularls", 
                    "html", 
                    "cssls", 
                    "ts_ls" 
                },
                handlers = {
                    -- The first entry (without a key) is the default handler
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,

                    -- Specific configuration for Angular
                    ["angularls"] = function()
                        lspconfig.angularls.setup({
                            capabilities = capabilities,
                            -- This helps the LSP find the "root" of your Angular project
                            -- It looks for these files to realize it should start working
                            root_dir = lspconfig.util.root_pattern("angular.json", "project.json", "package.json"),
                            on_setup = function(new_config)
                                -- This is a common fix for AngularLS on some systems to ensure 
                                -- it handles templates correctly
                                new_config.settings = {
                                    angular = {
                                        suggest = {
                                            includeCompletionsWithSnippetText = true,
                                            includeAutomaticOptionalChainCompletions = true,
                                        }
                                    }
                                }
                            end,
                        })
                    end,

                    -- Specific configuration for OmniSharp
                    ["omnisharp"] = function()
                        lspconfig.omnisharp.setup({
                            capabilities = capabilities,
                            -- On Windows, 'OmniSharp' (with capital O and S) is the standard cmd name
                            cmd = { "OmniSharp" }, 
                            root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", ".git"),
                            -- Optimizations for C# development
                            enable_roslyn_analyzers = true,
                            organize_imports_on_format = true,
                            enable_import_completion = true,
                            analyze_open_documents_only = true,
                        })
                    end,

                    -- Specific configuration for Lua
                    ["lua_ls"] = function()
                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim" },
                                    },
                                },
                            },
                        })
                    end,
                },
            })

            -- 4. LSP Keymaps (LspAttach)
            -- This triggers ONLY when a language server successfully connects to a buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    
                    -- Basic LSP Actions
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

                    -- Telescope LSP Pickers
                    local builtin = require('telescope.builtin')
                    vim.keymap.set('n', 'gr', builtin.lsp_references, opts)
                    vim.keymap.set('n', 'gi', builtin.lsp_implementations, opts)
                    vim.keymap.set('n', 'gs', builtin.lsp_document_symbols, opts)
                end,
            })
        end
    }
}

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim", -- plugin to install LSP's
            "williamboman/mason-lspconfig.nvim",
        },

        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "bashls" },
            })

            -- 1. Grab the capabilities from nvim-cmp
            -- This tells the LSP: "Hey, I have a fancy autocomplete menu!"
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local lsp = vim.lsp

            -- 2. Setup servers
            if lsp.config then
                -- Native Neovim 0.11+ way
                lsp.config('lua_ls', {
                    capabilities = capabilities,
                    settings = {
                        Lua = { diagnostics = { globals = { "vim" } } }
                    }
                })
                lsp.enable('lua_ls')

                lsp.config('bashls', { capabilities = capabilities })
                lsp.enable('bashls')
            else
                -- Fallback for Neovim 0.10 (Standard lspconfig)
                local lspconfig = require("lspconfig")

                lspconfig.lua_ls.setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = { diagnostics = { globals = { "vim" } } }
                    }
                })

                lspconfig.bashls.setup({
                    capabilities = capabilities
                })
            end

            -- 3. Autocmd for keymaps 
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                end,
            })
        end
    }
}

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "nvim-telescope/telescope.nvim", -- Assumed to be installed for references
        },

        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "bashls" },
            })

            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local lsp = vim.lsp

            -- 1. Setup servers
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
                    -- Core LSP keymaps
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

                    -- Renaming
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

                    -- Telescope Keymaps (Requires telescope.nvim plugin)
                    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
                    vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, opts)
                    vim.keymap.set('n', 'gs', require('telescope.builtin').lsp_document_symbols, opts)
                end,
            })
        end
    }
}

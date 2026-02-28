return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim", -- plugin to install LSP's
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            -- 1. Setup Mason
            require("mason").setup()

            -- 2. Setup Mason-LSPConfig
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "bashls" },
            })

            -- 3. Setup servers using the new Neovim 0.11+ way
            -- We use lspconfig only to trigger the setups now
            local lspconfig = require("lspconfig")

            -- Setup Lua
            lspconfig.lua_ls.setup({
                -- The new way often prefers passing settings directly
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } }
                    }
                }
            })

            -- Setup Bash
            lspconfig.bashls.setup({})

            -- 4. Keymaps (Modern way: use LspAttach autocmd)
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
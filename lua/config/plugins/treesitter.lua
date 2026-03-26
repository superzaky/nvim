return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        -- version = "v0.9.3",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                -- Add languages you use here
                ensure_installed = { 
                    "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "bash",
                    "html", "css", "typescript", "javascript" 
                },
                -- Automatically install missing parsers when you open a new filetype (note currently set to false)
                auto_install = false,

                highlight = {
                    enable = true, -- This is the line that turns on colors
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },
}

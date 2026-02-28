return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup({
            -- Optional: Customize the view
            view_options = {
                show_hidden = true, -- Show dotfiles
            },
        })

        -- Keymap to open Oil in the current directory
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
}
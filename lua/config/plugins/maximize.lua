return {
    "declancm/maximize.nvim",
    config = function()
        require("maximize").setup()

        -- Keymap to toggle maximizing the current window
        vim.keymap.set("n", "<leader>z", function()
            require("maximize").toggle()
        end, { desc = "Toggle Maximize Split" })
    end,
}

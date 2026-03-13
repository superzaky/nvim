-- space is my leader button
vim.g.mapleader =  " "
-- when opening a folder and then a file via VIM, then you can press space pv to go back to the browser page
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
-- You can highlight a word, press <leader>p, highlight another word, press <leader>p again, 
-- and it will keep pasting the same original text every single time.
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Move between splitted windows easily
vim.keymap.set('n', '<C-h>', '<C-w>h') -- Move left
vim.keymap.set('n', '<C-j>', '<C-w>j') -- Move down
vim.keymap.set('n', '<C-k>', '<C-w>k') -- Move up
vim.keymap.set('n', '<C-l>', '<C-w>l') -- Move right

-- to move text while in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- this takes the line below you and append to your current line, while letting your cursor to remain on the same place.
vim.keymap.set("n", "J", "mzJ`z")

-- this allows page jumping with ctrl+d or ctrl+u, while letting your cursor remain on the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- this allows your cursor to remain on the middle, while navigating your search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Clean and then Build
-- vim.keymap.set('n', '<leader>fc', ':!dotnet clean; dotnet build<CR>', { desc = '[F]ormat [C]lean & Build' })
-- For Windows Neovim users
vim.keymap.set('n', '<leader>fc', '<cmd>!dotnet clean && dotnet build<CR>', { desc = 'Clean and Build' })

-- Copy ONLY the filename (e.g., Program.cs)
vim.keymap.set('n', '<leader>fn', function()
    vim.fn.setreg('+', vim.fn.expand("%:t"))
    print("Copied filename: " .. vim.fn.expand("%:t"))
end, { desc = "Copy Filename" })

-- onderstaande auto refresh werkt niet, dus gebruik iets anders
-- -- Create a variable to track the state
-- vim.g.auto_refresh_enabled = false

-- -- Function to toggle the behavior
-- function ToggleAutoRefresh()
--   if vim.g.auto_refresh_enabled then
--     vim.api.nvim_clear_autocmds({ group = "AutoRefresh" })
--     vim.g.auto_refresh_enabled = false
--     print("Auto refresh disabled")
--   else
--     vim.o.autoread = true
--     vim.api.nvim_create_augroup("AutoRefresh", { clear = true })
--     vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
--       group = "AutoRefresh",
--       command = "if mode() != 'c' | checktime | endif",
--       pattern = "*",
--     })
--     vim.g.auto_refresh_enabled = true
--     print("Auto refresh enabled")
--   end
-- end

-- vim.keymap.set('n', '<leader>ar', ToggleAutoRefresh, { 
--   noremap = true, 
--   silent = false,
--   desc = "Toggle auto refresh of files" 
-- })

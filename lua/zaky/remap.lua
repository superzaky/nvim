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

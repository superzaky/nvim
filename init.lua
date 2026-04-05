require("config.lazy")
-- require("lazy").setup("plugins")
require("zaky")
print("hello")

-- this is needed so that the hightlight config from lsp.lua will occur after 100ms
vim.opt.updatetime = 100
-- Set the number of spaces a <Tab> counts for
vim.opt.tabstop = 4

-- Set the number of spaces for (auto) indenting
vim.opt.shiftwidth = 4

-- Insert spaces when pressing the <Tab> key
vim.opt.expandtab = true
-- use system clipboard for all copy/paste operations
vim.opt.clipboard = "unnamedplus"
vim.opt["tabstop"] = 4
vim.opt["shiftwidth"] = 4

-- regarding line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- REGARDING SPLITTING WINDOWS
-- splitbelow = true: When you create a horizontal split (using :split or :sp), 
-- the new window will open below your current one. (The default is above, which often feels upside down).

-- splitright = true: When you create a vertical split (using :vsplit or :vs), 
-- the new window will open to the right of your current one. (The default is the left).
vim.opt.splitbelow = true
vim.opt.splitright = true

-- This allows you to not keep search results highlighted after you are done with your search
vim.opt.hlsearch = false
require("config.lazy")
require("lazy").setup("plugins")
require("zaky")
print("hello")

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


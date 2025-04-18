-- nvim options

-- setting leaders
vim.g.mapleader		= " "
vim.g.maplocalleader 	= "\\"

-- sync with system clipboard
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" 

-- enable line numbers
vim.opt.number = true

-- make each shift 5 spaces long
vim.opt.shiftwidth = 5
-- make each tab 5 spaces long
vim.opt.tabstop = 5


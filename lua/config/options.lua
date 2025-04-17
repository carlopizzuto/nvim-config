local opt = vim.opt


vim.g.mapleader		= " "
vim.g.maplocalleader 	= "\\"

-- sync with system clipboard
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" 

-- enable line numbers
opt.number = true

-- make each shift 5 spaces long
opt.shiftwidth = 5
-- make each tab 5 spaces long
opt.tabstop = 5


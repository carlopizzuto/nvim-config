local opt = vim.opt


vim.g.mapleader		= " "
vim.g.maplocalleader 	= "\\"

opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

opt.number = true

opt.shiftwidth = 5
opt.tabstop = 5


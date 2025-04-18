-- nvim keymaps

-- open nvim-tree file explorer 
vim.keymap.set("n", "<leader>e", "<CMD>NvimTreeToggle<CR>", { desc = "Toggle Nvim Tree File Explorer", noremap = true, silent = true })

-- telescope keymaps
vim.keymap.set("n", "<leader>ff", "<CMD>Telescope find_files<CR>", { desc = "Find Files", silent = true })
vim.keymap.set("n", "<leader>fb", "<CMD>Telescope buffers<CR>", { desc = "Buffers" })

-- nvim keymaps

-- open Lazy
vim.keymap.set("n", "<leader>L", "<CMD>Lazy<CR>", { desc = "Open Lazy", noremap = true, silent = true })

-- open Telescope
vim.keymap.set("n", "<leader>T", "<CMD>Telescope<CR>", { desc = "Open Telescope", noremap = true, silent = true })


-- open nvim-tree file explorer 
vim.keymap.set("n", "<leader>e", "<CMD>NvimTreeToggle<CR>", { desc = "Toggle Nvim Tree File Explorer", noremap = true, silent = true })

-- telescope keymaps
vim.keymap.set("n", "<leader>ff", "<CMD>Telescope find_files<CR>", { desc = "Find Files", silent = true })
vim.keymap.set("n", "<leader>fb", "<CMD>Telescope buffers<CR>", { desc = "Buffers" })

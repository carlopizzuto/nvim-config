-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Import Options
require("config.options")

-- Setup lazy.nvim
require("lazy").setup({
  	spec = {
    		{ import = "plugins" },
    		{ import = "plugins.colorschemes.kanagawa" },
  	},

  	checker = {
    		enabled = true,
  	},

	performance = {
		rtp = {
     		-- disable some rtp plugins
      		disabled_plugins = {
     			"gzip",
   				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
      		},
    		},
  	},

})

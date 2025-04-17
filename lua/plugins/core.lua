return {
	-- 1. Core
  	{ "nvim-lua/plenary.nvim", lazy = false },
	
	-- which key; popup of nvim keys
	{
		"folke/which-key.nvim",
  		event = "VeryLazy",
  		opts = {
      		},
  		keys = { 
			{ 
				"<leader>?",
      			function()
        				require("which-key").show({ global = false })
      			end,
      			desc = "Buffer Local Keymaps (which-key)", 
			},
  		},
	},

  	-- 2. Telescope + extension -------------------------------------------
  	{
    		"nvim-telescope/telescope.nvim",
    		cmd = "Telescope",
    		dependencies = { "nvim-lua/plenary.nvim" },
    		opts = { defaults = { layout_strategy = "flex" } },
  	},
  	{ 
		"polirritmico/telescope-lazy-plugins.nvim", -- optional plugin search
    		config = function() 
			require("telescope").load_extension("lazy_plugins") 
		end,
    		dependencies = { "nvim-telescope/telescope.nvim" },
  	},

  	-- 3. Treesitter -------------------------------------------------------
  	{ 
		"nvim-treesitter/nvim-treesitter",
    		opts = {
			ensure_installed = {
        			"bash",
				"c",
        			"html",
        			"javascript",
        			"json",
        			"lua",
        			"markdown",
        			"markdown_inline",
        			"python",
        			"query",
        			"regex",
        			"tsx",
        			"typescript",
        			"vim",
        			"yaml",
      		},
    		},
  	},
}


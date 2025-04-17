-- ~/.config/nvim/lua/plugins/lsp.lua
return {
	{ "neovim/nvim-lspconfig" },
  	
	{ "williamboman/mason.nvim", build = ":MasonUpdate" },
  	
	{ 
		"williamboman/mason-lspconfig.nvim",
    		opts = {
			ensure_installed = { "lua_ls", "pyright", "rust_analyzer" },
			automatic_installation = true,
		},
		config = function(_, opts)
			require("mason").setup()
			require("mason-lspconfig").setup(opts)
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
							disable = {},
						},
						telemetry = {
							false
						},
					},
				},
			})

			lspconfig.pyright.setup({})

      		lspconfig.rust_analyzer.setup({})
    		end,
  	},
  	
	{ 
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" },
		config = function()
      			local cmp = require("cmp")
			cmp.setup({
				sources = { { name = "nvim_lsp" } },
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping.confirm({ select = true }),
        			}),
      		})
    		end,
	},
}


--  ██████╗ ██╗      ██████╗  ██████╗ ██╗   ██╗███╗   ██╗███████╗
--  ██╔══██╗██║     ██╔═══██╗██╔════╝ ██║   ██║████╗  ██║██╔════╝
--  ██████╔╝██║     ██║   ██║██║  ███╗██║   ██║██╔██╗ ██║███████╗
--  ██╔══██╗██║     ██║   ██║██║   ██║██║   ██║██║╚██╗██║╚════██║
--  ██████╔╝███████╗╚██████╔╝╚██████╔╝╚██████╔╝██║ ╚████║███████║
--  ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝
--
--  ❯  plugins.lua  (single‑file spec for lazy.nvim)

return {

	------------------------------------------------------------------
	--  0.  COLOURSCHEME & UI
	------------------------------------------------------------------
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled        = true,
					theme                = "auto",
					component_separators = { left = "", right = "" },
					section_separators   = { left = "", right = "" },
					always_divide_middle = true,
					always_show_tabline  = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
	{ "folke/which-key.nvim", event = "VeryLazy", opts = {} },
	{
		"gelguy/wilder.nvim",
		event = "CmdlineEnter",
		build = ":UpdateRemotePlugins",
		config = function()
			local wilder = require("wilder")
			wilder.setup({
				modes = { ":", "/", "?" },
				next_key      = "<Down>",
				previous_key  = "<Up>",
				accept_key    = "<S-CR>",
			})
			wilder.set_option("pipeline", {
				wilder.branch(
					wilder.cmdline_pipeline(),
					wilder.search_pipeline()
				),
			})
			wilder.set_option("renderer", wilder.popupmenu_renderer({
				highlighter = wilder.basic_highlighter(),
				left        = { " ", wilder.popupmenu_devicons() },
				right       = { " ", wilder.popupmenu_scrollbar() },
			}))
		end,
	},

	------------------------------------------------------------------
	--  1.  NAVIGATION / SEARCH
	------------------------------------------------------------------
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			defaults = {
				layout_strategy      = "flex",
				file_ignore_patterns = {
					"/venv/", "/env/", "/node_modules/", "/__pycache__/", "/%.egg%-info/",
				},
			},
		},
	},
	{
		"polirritmico/telescope-lazy-plugins.nvim",
		dependencies = "nvim-telescope/telescope.nvim",
		config = function() require("telescope").load_extension("lazy_plugins") end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
		config = function() require("nvim-tree").setup() end,
	},

	------------------------------------------------------------------
	--  2.  EDITING AIDS
	------------------------------------------------------------------
	{ "smjonas/inc-rename.nvim", cmd = "IncRename", config = true },
	{
		"echasnovski/mini.bracketed",
		event = "BufReadPost",
		config = function()
			require("mini.bracketed").setup({
				file       = { suffix = "" },
				window     = { suffix = "" },
				quickfix   = { suffix = "" },
				yank       = { suffix = "" },
				treesitter = { suffix = "n" },
			})
		end,
	},

	------------------------------------------------------------------
	--  3.  TREESITTER & SYNTAX
	------------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			highlight = { enable = true },
			indent    = { enable = true },
			ensure_installed = {
				"bash", "c", "cpp", "html", "javascript", "json", "lua", "markdown",
				"markdown_inline", "python", "query", "regex", "tsx", "typescript",
				"vim", "yaml",
			},
		},
		config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
	},


	------------------------------------------------------------------
	--  4.  LSP  +  COMPLETION +  AI
	------------------------------------------------------------------
	{
		-- 4-a.  LSP core
		"neovim/nvim-lspconfig",
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
		opts = {
			ensure_installed        = { "lua_ls", "pyright", "rust_analyzer", "clangd" },
			automatic_installation  = true,
		},
		config = function(_, opts)
			require("mason").setup()
			require("mason-lspconfig").setup(opts)

			local lsp = require("lspconfig")

			-- Lua
			lsp.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						telemetry   = { enable = false },
					},
				},
			})

			-- Python / 
			lsp.pyright.setup({})
			-- C-C++ / 
			lsp.clangd.setup({})
			-- Rust /
			lsp.rust_analyzer.setup({})
		end,
	},

	{
		"github/copilot.vim",
	},

	------------------------------------------------------------------
	--  4-b. nvim-cmp 
	------------------------------------------------------------------
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				completion = { autocomplete = false },

				snippet = {
					expand = function(args) require("luasnip").lsp_expand(args.body) end,
				},

				-- ── KEYMAPS ─────────────────────────────────────────────────
				mapping = {
					-- open the menu manually
					["<C-Space>"] = cmp.mapping.complete(),

					-- navigate with ⬆ / ⬇
					["<Up>"]      = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<Down>"]    = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),

					-- ⇧ Enter  → confirm the highlighted item
					["<S-CR>"]    = cmp.mapping.confirm({ select = true }),

					-- keep <CR>, <Tab>, <S-Tab> totally free
					["<CR>"]      = cmp.config.disable,
					["<Tab>"]     = cmp.config.disable,
					["<S-Tab>"]   = cmp.config.disable,
				},
				-- SOURCES (AI first so it’s preferred)
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				},

				-- INLINE GHOST TEXT
				experimental = {
					ghost_text = { hl_group = "Comment" },
				},
			})
		end,
	},


	------------------------------------------------------------------
	--  5.  SUPPORT LIBS
	------------------------------------------------------------------
	{ "nvim-lua/plenary.nvim", lazy = true },
}

--  ██████╗ ██╗      ██████╗  ██████╗ ██╗   ██╗███╗   ██╗███╗   ██╗
--  ██╔══██╗██║     ██╔═══██╗██╔════╝ ██║   ██║████╗  ██║████╗  ██║
--  ██████╔╝██║     ██║   ██║██║  ███╗██║   ██║██╔██╗ ██║██╔██╗ ██║   
--  ██╔══██╗██║     ██║   ██║██║   ██║██║   ██║██║╚██╗██║██║╚██╗██║   
--  ██████╔╝███████╗╚██████╔╝╚██████╔╝╚██████╔╝██║ ╚████║██║ ╚████║
--  ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝
--  
--  ❯  plugins.lua
--  ❯  single-spec for lazy.nvim
--  ❯  All plugins live here.
--  ❯  Anything marked “★ suggestion” is an optional tweak.

return {

  ------------------------------------------------------------------
  --  0.  COLOURSCHEME & UI
  ------------------------------------------------------------------
 
	-- Icons used by nvim-tree / lualine / telescope
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        -- unchanged (your original lines) ↓
        options = {
          icons_enabled        = true,
          theme                = "auto",
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
          always_divide_middle = true,
          always_show_tabline  = true,
        },
        sections = {         -- shortened a bit for clarity
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

  -- Which-key popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {},              -- original (no changes needed)
  },

  -- Wilder command-line completion
  {
    "gelguy/wilder.nvim",
    event = "CmdlineEnter",
    build = ":UpdateRemotePlugins",
    config = function()
      local wilder = require("wilder")
      wilder.setup({ modes = { ":", "/", "?" } })
      wilder.set_option("pipeline", {
  	   wilder.branch(
          wilder.cmdline_pipeline(),
          wilder.search_pipeline()
         ),
	  })

	  wilder.set_option("renderer", wilder.popupmenu_renderer({
  	    highlighter = wilder.basic_highlighter(),   -- ✓
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
        file_ignore_patterns = {  -- hide Python virtual-envs (add more if you like)
          "/venv/",
          "/env/",
		"/node_modules/",
        },
      },
    },
  },
  {
    "polirritmico/telescope-lazy-plugins.nvim",
    config = function() require("telescope").load_extension("lazy_plugins") end,
    dependencies = "nvim-telescope/telescope.nvim",
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },  -- ★ suggestion: lazy-load
    config = function() require("nvim-tree").setup() end,
  },

  ------------------------------------------------------------------
  --  2.  EDITING AIDS
  ------------------------------------------------------------------
  -- Incremental rename (LSP-powered)
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = function() require("inc-rename").setup() end,
  },

  -- Extra “\[ \]” motions
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
      -- ★ suggestion: keep C/C++ parsers up-to-date
      ensure_installed = {
        "bash", "c", "cpp", "html", "javascript", "json",
        "lua", "markdown", "markdown_inline", "python",
        "query", "regex", "tsx", "typescript", "vim", "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  ------------------------------------------------------------------
  --  4.  LSP  +  COMPLETION
  ------------------------------------------------------------------
  { "neovim/nvim-lspconfig" },

  { "williamboman/mason.nvim", build = ":MasonUpdate" },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
    opts = {
      -- added clangd ↓
      ensure_installed = { "lua_ls", "pyright", "rust_analyzer", "clangd" },
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason").setup()
      require("mason-lspconfig").setup(opts)

      local lspconfig = require("lspconfig")

      -- C / C++  (★ new)
      lspconfig.clangd.setup({})

      -- Lua
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            telemetry   = { enable = false },
          },
        },
      })

      -- Python
      lspconfig.pyright.setup({})

      -- Rust
      lspconfig.rust_analyzer.setup({})
    end,
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = { { name = "nvim_lsp" } },
      })
    end,
  },

  ------------------------------------------------------------------
  --  5.  SUPPORT LIBS
  ------------------------------------------------------------------
  { "nvim-lua/plenary.nvim", lazy = true },   -- utility functions

}


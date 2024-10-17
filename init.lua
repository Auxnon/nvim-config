-- bootstrap lazy package manager
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
-- end bootstrap

vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

vim.g.mapleader = " "
vim.opt.tabstop = 4 -- A TAB character looks like 4 spaces
vim.opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.opt.smartindent = true
vim.bo.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.opt.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.wo.number = true
vim.wo.relativenumber = true
-- vim.opt.number=true
-- vim.opt.relativenumber=true
-- vim.opt.signcolumn="number"

vim.g.surround_no_mappings = true
-- plugins

require("lazy").setup({
	"tpope/vim-surround",
	"nvim-lua/plenary.nvim",
	{ "nvim-telescope/telescope.nvim" },
	{ "rose-pine/neovim", name = "rose-pine" },
	{ "jokajak/keyseer.nvim", version = false },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	"mbbill/undotree",
	"tpope/vim-fugitive",
	--- Uncomment the two plugins below if you want to manage the language servers from neovim
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },

	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/nvim-cmp",
	"L3MON4D3/LuaSnip",
	"MunifTanjim/prettier.nvim",
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				-- configuration goes here, for example:
				setopt = true,
				relculright = true,
				segments = {
					{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
					{
						sign = { name = { "Diagnostic" }, maxwidth = 2, auto = true },
						click = "v:lua.ScSa",
					},
					{ text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
					{
						sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
						click = "v:lua.ScSa",
					},
				},
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},
	"mhartington/formatter.nvim",
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		lazy = false, -- This plugin is already lazy
		auto_focus = true,
	},
	{
		"saecki/crates.nvim",
		tag = "stable",
		config = function()
			require("crates").setup()
		end,
	},
	"rcarriga/nvim-notify",
	"mfussenegger/nvim-dap",
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			keymaps = {
				["q"] = "actions.close",
			},
		},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	},
	"ggandor/leap.nvim",
})

require("maps")

print("nvim lua loaded")

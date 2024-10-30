-- set to false to make clipboard use osc52 mode, otherwise force unnamedplus for that juicy clippy goodness
LocalVim=false

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

vim.opt.termguicolors = true

vim.g.mapleader = " "
vim.opt.tabstop = 4 -- A TAB character looks like 4 spaces
vim.opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.opt.smartindent = true
vim.bo.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.opt.shiftwidth = 4 -- Number of spaces inserted when indenting


vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.wo.number = true
vim.wo.relativenumber = true
vim.o.statuscolumn = "%!v:lua.require('statcol').statcol()"
-- vim.opt.number=true
-- vim.opt.relativenumber=true
-- vim.opt.signcolumn="number"

vim.g.surround_no_mappings = true

if LocalVim then
	vim.opt.clipboard = "unnamedplus"
else
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
end

-- plugins

require "lazy".setup({
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
		config = function() require("crates").setup() end,
	},
	"rcarriga/nvim-notify",
	"mfussenegger/nvim-dap",
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			use_default_keymaps = false,
			keymaps = {
				["q"] = "actions.close",
				--  ["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-s>"] = {
					"actions.select",
					opts = { vertical = true },
					desc = "Open the entry in a vertical split",
				},
				["<C-h>"] = {
					"actions.select",
					opts = { horizontal = true },
					desc = "Open the entry in a horizontal split",
				},
				["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
				["<C-p>"] = "actions.preview",
				["<C-c>"] = "actions.close",
				-- ["<C-l>"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				-- ["`"] = "actions.cd",
				-- ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory", mode = "n" },
				-- ["gs"] = "actions.change_sort",
				-- ["gx"] = "actions.open_external",
				-- ["g."] = "actions.toggle_hidden",
				-- ["g\\"] = "actions.toggle_trash",
			},
		},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	},
	"ggandor/leap.nvim",
	"wellle/targets.vim",
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				-- Recommended - see "Configuring" below for more config options
				transparent = true,
				italic_comments = true,
				hide_fillchars = true,
				borderless_telescope = true,
				terminal_colors = true,
				-- theme = { variant = "light", colors = { bg = "#ffffff" } },
			})
			vim.cmd("colorscheme cyberdream") -- set the colorscheme
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{ "akinsho/toggleterm.nvim", version = "*", opts = {
		open_mapping = [[<c-t>]],
		shell = "fish",
	} },
	{
		"chentoast/marks.nvim",
		event = "VeryLazy",
		opts = {},
	},
	"lewis6991/gitsigns.nvim",
	"catgoose/telescope-helpgrep.nvim",
})

require("maps")

print "🌻"

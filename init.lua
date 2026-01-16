-- set to false to make clipboard use osc52 mode, otherwise force unnamedplus for that juicy clippy goodness
LocalVim = false

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
-- TODO
-- WARN
-- TEST
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

-- for ufo
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
-- end ufo

-- plugins

require "lazy".setup({
	"tpope/vim-surround",
	"nvim-lua/plenary.nvim",
	{ "nvim-telescope/telescope.nvim" },
	{ "rose-pine/neovim", name = "rose-pine" },
	{ "jokajak/keyseer.nvim", version = false },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"nvim-treesitter/nvim-treesitter-textobjects",
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
	-- { "zbirenbaum/copilot.lua", event = "VeryLazy" },
	"L3MON4D3/LuaSnip",
	"MunifTanjim/prettier.nvim",
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		---@class wk.Opts
		opts = {
			preset = "modern",
			spec = {
				{ "<leader>d", group = "Del" },
				{ "<leader>s", group = "Swap" },
				{ "<leader>g", group = "Go" },
				{ "<leader>h", group = "Hunk" },
				{ "<leader>l", group = "LSP" },
				{ "<leader>o", group = "Over" },
				{ "<leader>c", group = "AI" },
				{ "<leader>p", group = "pFile" },
				{ "<leader>t", group = "Toggle" },
				{ "<leader>x", group = "Trouble" },
			},
			icons = {
				rules = {
					{ pattern = "go", icon = " ", color = "purple" },
					{ pattern = "swap", icon = " ", color = "green" },
					{ pattern = "hunk", icon = " ", color = "cyan" },
					{ pattern = "lsp", icon = " ", color = "yellow" },
					{ pattern = "del", icon = " ", color = "orange" },
					{ pattern = "over", icon = " ", color = "yellow" },
					{ pattern = "ai", icon = "󱙺 ", color = "blue" },
					{ pattern = "pfile", icon = " ", color = "purple" },
					{ pattern = "undo", icon = "󰕍 ", color = "orange" },
					{ pattern = "harpoon", icon = "󰛢 ", color = "purple" },
					{ pattern = "toggle", icon = "󰨚 ", color = "yellow" },
					{ pattern = "trouble", icon = " ", color = "yellow" },
				},
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},
	"mhartington/formatter.nvim",
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
		auto_focus = true,
        
	},
	-- {
	-- 	"nwiizo/cargo.nvim",
	-- 	build = "cargo build --release",
	-- 	config = function()
	-- 		require("cargo").setup({
	-- 			float_window = true,
	-- 			window_width = 0.8,
	-- 			window_height = 0.8,
	-- 			border = "rounded",
	-- 			auto_close = true,
	-- 			close_timeout = 5000,
	-- 		})
	-- 	end,
	-- 	ft = { "rust" },
	-- 	cmd = {
	-- 		"CargoBench",
	-- 		"CargoBuild",
	-- 		"CargoClean",
	-- 		"CargoDoc",
	-- 		"CargoNew",
	-- 		"CargoRun",
	-- 		"CargoTest",
	-- 		"CargoUpdate",
	-- 	},
	-- },
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
				-- ["<C-s>"] = {
				-- 	"actions.select",
				-- 	opts = { vertical = true },
				-- 	desc = "Open the entry in a vertical split",
				-- },
				["<C-s>"] = function() require "oil".save { confirm = false } end,
				-- ["<C-h>"] = {
				-- 	"actions.select",
				-- 	opts = { horizontal = true },
				-- 	desc = "Open the entry in a horizontal split",
				-- },
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
				["g."] = "actions.toggle_hidden",
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
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			-- open_mapping = [[<c-t>]],
			shell = "fish",
		},
	},
	{
		"chentoast/marks.nvim",
		event = "VeryLazy",
		opts = {},
	},
	"lewis6991/gitsigns.nvim",
	{
		"stevearc/aerial.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	"catgoose/telescope-helpgrep.nvim",
	{ "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async" },
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>os",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>ol",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{ "sindrets/diffview.nvim", command = "DiffviewOpen", cond = is_git_root },
	{
		"olimorris/codecompanion.nvim",
		config = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			strategies = {
				-- Change the default chat adapter
				chat = {
					adapter = "anthropic",
				},
			},
		},
	},
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function() require("go").setup() end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
    {
        "mfussenegger/nvim-jdtls",
    }
    -- "klen/nvim-test",
})

require("maps")

vim.g.rustaceanvim = {
	-- Plugin configuration
	-- tools = {},
	-- LSP configuration
	server = {
		-- on_attach = function(client, bufnr)
		-- 	-- you can also put keymaps in here
		-- end,
		default_settings = {
			-- rust-analyzer language server configuration
			["rust-analyzer"] = {
				diagnostics = {
					disabled = { "inactive-code" },
				},
			},
		},
	},
	-- DAP configuration
	-- dap = {},
}
print "🌻"

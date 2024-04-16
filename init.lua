
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
vim.opt.clipboard = "unnamedplus"
-- end bootstrap

vim.g.mapleader = " "


-- plugins

require("lazy").setup({
 'tpope/vim-surround',
 'nvim-lua/plenary.nvim',
 {'nvim-telescope/telescope.nvim'},
 { "rose-pine/neovim", name = "rose-pine" },
 { 'jokajak/keyseer.nvim', version = false },
 {'nvim-treesitter/nvim-treesitter', build=":TSUpdate"},
 {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
},
"mbbill/undotree",
"tpope/vim-fugitive",
--- Uncomment the two plugins below if you want to manage the language servers from neovim
{'williamboman/mason.nvim'},
{'williamboman/mason-lspconfig.nvim'},

{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
{'neovim/nvim-lspconfig'},
{'hrsh7th/cmp-nvim-lsp'},
{'hrsh7th/nvim-cmp'},
{'L3MON4D3/LuaSnip'},
})

require "maps"

print "nvim lua loaded"

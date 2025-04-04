local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- here you can setup the language servers
local lspconfig = require("lspconfig")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require("mason").setup({})
require("mason-lspconfig").setup({
	--  ensure_installed = {
	-- 'rust_analyzer',
	--  },
	handlers = {
		function(server_name)
			lspconfig[server_name].setup({
				capabilities = capabilities,
			})
		end,
	},
})
require("ufo").setup()

if lspconfig.lua_ls then
	lspconfig.lua_ls.setup({
		settings = {
			Lua = {
				-- workspace={
				--     library={
				--         [vim.fn.expand'$VIMRUNTIME/lua']=true,
				--         ['~/nvimout']=true,
				--     }
				-- },
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	})
end

if lspconfig.emmet_language_server then
	lspconfig.emmet_language_server.setup {
		-- on_attach = on_attach,
		capabilities = capabilities,
		filetypes = {
			"css",
			"eruby",
			"html",
			"javascript",
			"javascriptreact",
			"less",
			"sass",
			"scss",
			"svelte",
			"pug",
			"typescriptreact",
			"vue",
		},
	}
end

--- we must manually point our lexical lsp to it's install that we built to _build and moved to ~/bin/lexical-lsp 
--- https://github.com/lexical-lsp/lexical/blob/main/pages/installation.md#neovim
if lspconfig.lexical then
	lspconfig.lexical.setup {
		cmd = { vim.env.HOME.."/bin/lexical-lsp/package/lexical/bin/start_lexical.sh" },
		root_dir = function(fname) return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd() end,
		filetypes = { "elixir", "eelixir", "heex" },
		-- optional settings
		settings = {},
	}
end

local cmp = require("cmp")
-- local cmp_select = {behavior = cmp.SelectBehavior.Select}
-- local cmp_mappings = lsp.default.cmp_mappings {
-- 	["<C-p>"] = cmp.mappings.select_prev_item(cmp_select),
-- 	["<C-n>"] = cmp.mappings.select_next_item(cmp_select),
-- 	["<C-y>"] = cmp.mappings.confirm{select=true},
-- 	["<C-Space>"] = cmp.mappings.complete(),
-- }

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-z>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "copilot", group_index = 2 },
		{ name = "nvim_lsp" },
		-- { name = 'vsnip' }, -- For vsnip users.
		{ name = "luasnip" }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = "buffer" },
	}),
})

-- lsp.set_preferences{
-- 	sign_icons={}
-- }

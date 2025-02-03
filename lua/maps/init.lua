vim.g.mapleader = " "
local flipm = require("flip")
local utils = require("utils")
local k = vim.keymap
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- vim.keymap.set("n", "<leader>pv", "<Cmd>Oil --float .<CR>")
vim.keymap.set("n", "<leader>pv", function() require("oil").open() end)

local opts = nil
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Go to def" })
-- vim.keymap.set("n", "K", function() vim.lsp.inlay_hint.enable(true) end, opts)
vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, { desc = "LSP replace" })
vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
vim.keymap.set("n", "<leader>l[", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>l]", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<C-e>", function() vim.diagnostic.goto_next { severity=vim.diagnostic.severity.ERROR } end)
vim.keymap.set("n", "<C-f>", vim.cmd.Format)
vim.keymap.set("v", "<C-f>", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>sr", ":%s/<C-r>0//g<Left><Left>", { desc = "Replace all instances of clipboard in text" })
vim.keymap.set("v", "<leader>sr", "y:%s/<C-r>0//g<Left><Left>", { desc = "Replace all instances of text selection" })
vim.keymap.set("n", "<leader>sR", function()
	local old_word = vim.fn.expand("<cword>")
	local new_word = vim.fn.input("Replace " .. old_word .. " by? ", old_word)
	-- Check if the new_word is different from the old_word and is not empty
	if new_word ~= old_word and new_word ~= "" then vim.cmd(":%s/\\<" .. old_word .. "\\>/" .. new_word .. "/g") end
end)
k.set("n", "<leader>lr", function() vim.lsp.buf.rename() end, { desc = "lsp replace word" })
k.set("n", "<leader>o", "<cmd>AerialToggle!<CR>", { desc = "Overview" })
-- k.set("n", "<leader>h", "yiw<Cmd>:h <C-R>0<CR>", { desc = "Overview" })
k.set("n", "Y", function()
	local count = math.max(vim.v.count, 1)
	local current_row = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())[1]
	local res = ""
	for i = 1, count do
		local f = vim.api.nvim_buf_get_lines(0, current_row - 1, current_row, false)[1]
		local stripped = string.gsub(f, "%s+", "")
		res = res .. stripped
		current_row = current_row + 1
	end
	vim.fn.setreg(LocalVim and "+" or "", res)
end, { desc = "copy one or more lines stripping trailing whitespace and new lines into one" })
require("leap").create_default_mappings()
require("leap.user").set_repeat_keys("<enter>", "<backspace>")

k.set("n", "ds", "<Plug>Dsurround")
k.set("n", "cs", "<Plug>Csurround")
k.set("n", "cS", "<Plug>CSurround")
k.set("n", "ys", "<Plug>Ysurround")
k.set("n", "yS", "<Plug>YSurround")
k.set("n", "yss", "<Plug>Yssurround")
k.set("n", "ySs", "<Plug>YSsurround")
k.set("n", "ySS", "<Plug>YSsurround")
k.set("x", "S", "<Plug>VSurround")
k.set("x", "gS", "<Plug>VgSurround")
vim.fn.sign_define("s1", { text = "󰎤", texthl = "Type", linehl = "Search" })

vim.keymap.set("n", "<leader>k", function()
	local roo = vim.lsp.buf.list_workspace_folders()

	-- let buf = nvim_create_buf(v:false, v:true)
	-- call nvim_buf_set_lines(buf, 0, -1, v:true, ["test", "text"])
	-- let opts = {'relative': 'cursor', 'width': 10, 'height': 2, 'col': 0,
	--     \ 'row': 1, 'anchor': 'NW', 'style': 'minimal'}
	-- let win = nvim_open_win(buf, 0, opts)
	-- " optional: change highlight, otherwise Pmenu is used
	-- call nvim_set_option_value('winhl', 'Normal:MyHighlight', {'win': win})
	utils.menu(roo)

	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent = false })

	-- local current_row = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())[1]
	-- vim.fn.sign_place(0, "", "s1", vim.api.nvim_get_current_buf(), { lnum = current_row })
end)

-- true
k.set("n", "<C-c>", flipm.flip_it, { desc = 'Flip value/symbol to "opposite"' })
k.set("n", "<C-Up>", "<C-w><Up>")
k.set("n", "<C-Down>", "<C-w><Down>")
k.set("n", "<C-Left>", "<C-w><Left>")
k.set("n", "<C-Right>", "<C-w><Right>")
k.set("v", "<C-y>", "\"+y")

-- Session --------------
k.set("n", "<C-s>", "<Cmd>:w<CR>", { desc = "Save" })
k.set("n", "<leader>q", "<Cmd>:q<CR>", { desc = "Quit" })
-------------------------

-- k.set("n", "<leader>wv", function() vim.cmd.split({ mods = { vertical = true } }) end)
-- k.set("n", "<leader>wh", function() vim.cmd.split({ mods = { horizontal = true } }) end)

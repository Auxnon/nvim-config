vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", "<Cmd>Oil --float .<CR>")

local opts = nil
vim.keymap.set("n", "gd", function()
	vim.lsp.buf.definition()
end, opts)
-- vim.keymap.set("n", "K", function() vim.lsp.inlay_hint.enable(true) end, opts)
vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover()
end, opts)
vim.keymap.set("n", "<leader>r", function()
	vim.lsp.buf.rename()
end, opts)
vim.keymap.set("n", "<leader>vws", function()
	vim.lsp.buf.workspace_symbol()
end, opts)
vim.keymap.set("n", "<leader>vd", function()
	vim.diagnostic.open_float()
end, opts)
vim.keymap.set("n", "<C-f>", vim.cmd.Format)
vim.keymap.set("n", "<leader>sr", ":%s/<C-r>0//g<Left><Left>", { desc = "Replace all instances of clipboard in text" })
vim.keymap.set("v", "<leader>sr", "y:%s/<C-r>0//g<Left><Left>", { desc = "Replace all instances of text selection" })
vim.keymap.set("n", "<leader>sR", function()
	local old_word = vim.fn.expand("<cword>")
	local new_word = vim.fn.input("Replace " .. old_word .. " by? ", old_word)
	-- Check if the new_word is different from the old_word and is not empty
	if new_word ~= old_word and new_word ~= "" then
		vim.cmd(":%s/\\<" .. old_word .. "\\>/" .. new_word .. "/g")
	end
end)
local k = vim.keymap
k.set("n", "<C-s>", "<Cmd>:Format<CR><Cmd>:w<CR>")
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
	vim.fn.setreg("+", res)
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

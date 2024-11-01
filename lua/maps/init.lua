vim.g.mapleader = " "
local flipm = require("flip")
local k = vim.keymap
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", "<Cmd>Oil --float .<CR>")

local opts = nil
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
-- vim.keymap.set("n", "K", function() vim.lsp.inlay_hint.enable(true) end, opts)
vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, { desc = "lsp replace all of word" })
vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
vim.keymap.set("n", "<leader>l[", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>l]", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<C-e>", function() vim.diagnostic.goto_next { vim.diagnostic.severity.ERROR } end)
vim.keymap.set("n", "<C-f>", vim.cmd.Format)
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

local thingGroup = vim.api.nvim_create_augroup("Thing", {})
function ShowMenu(o, cb)
	-- local popup = require("plenary.popup")
	local height = 20
	local width = 30
	-- local borderchars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

	-- Win_id = popup.create(optsi, {
	-- 	title = "MyProjects",
	-- 	highlight = "MyProjectWindow",
	-- 	line = math.floor(((vim.o.lines - height) / 2) - 1),
	-- 	col = math.floor((vim.o.columns - width) / 2),
	-- 	minwidth = width,
	-- 	minheight = height,
	-- 	borderchars = borderchars,
	-- 	callback = cb,
	-- })

	local bufnr = vim.api.nvim_create_buf(false, true)
	local win_id = vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		title = o.title or "Test",
		title_pos = o.title_pos or "left",
		row = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		width = width,
		height = height,
		style = "minimal",
		border = o.border or "rounded",
	})

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, o)

	local closer = function()
		vim.api.nvim_win_close(win_id, true)
		vim.api.nvim_clear_autocmds({ group = "Thing" })
	end

	vim.api.nvim_create_autocmd({ "BufLeave" }, {
		group = thingGroup,
		buffer = bufnr,
		callback = closer,
	})

	-- ???
	vim.api.nvim_set_option_value("number", true, {
		win = win_id,
	})

	-- local bufnr = vim.api.nvim_win_get_buf(Win_id)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent=false })
	k.set("n", "q", closer, { buffer = bufnr, silent = false })
end

vim.keymap.set("n", "<leader>k", function()
	local roo = vim.lsp.buf.list_workspace_folders()

	-- let buf = nvim_create_buf(v:false, v:true)
	-- call nvim_buf_set_lines(buf, 0, -1, v:true, ["test", "text"])
	-- let opts = {'relative': 'cursor', 'width': 10, 'height': 2, 'col': 0,
	--     \ 'row': 1, 'anchor': 'NW', 'style': 'minimal'}
	-- let win = nvim_open_win(buf, 0, opts)
	-- " optional: change highlight, otherwise Pmenu is used
	-- call nvim_set_option_value('winhl', 'Normal:MyHighlight', {'win': win})
	ShowMenu(roo)

	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent = false })

	-- local current_row = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())[1]
	-- vim.fn.sign_place(0, "", "s1", vim.api.nvim_get_current_buf(), { lnum = current_row })
end)

k.set("n", "<C-F>", flipm.flip_it)

-- k.set("n", "<leader>wv", function() vim.cmd.split({ mods = { vertical = true } }) end)
-- k.set("n", "<leader>wh", function() vim.cmd.split({ mods = { horizontal = true } }) end)

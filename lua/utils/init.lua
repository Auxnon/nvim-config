local thingGroup = vim.api.nvim_create_augroup("Thing", {})
local m={}
function m.menu(o, cb)
	-- local popup = require("plenary.popup")
	local height = o.width or 20
	local width = o.height or 30
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

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, o[1])

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
	vim.keymap.set("n", "q", closer, { buffer = bufnr, silent = false })
    return bufnr
end

return m


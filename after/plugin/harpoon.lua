-- require("telescope").load_extension('harpoon')
---@type Harpoon
local harpoon = require "harpoon"
local k = vim.keymap
local wk = require "which-key"
local util = require "utils"

harpoon:setup({})
local harpy = vim.api.nvim_create_namespace "Harpy"

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

local function refresh_buffer(bufnr)
	local l = harpoon:list()
	local a = l:display()
	local new = {}
	for i = 1, #a do
		local v = a[i]
		local b = v:match(".*()/")
		if b ~= nil then v = v:sub(b + 1) end
		local item = l:get(i)
		local ind = #v
		if item ~= nil then v = v .. " " .. item.context.row .. "," .. item.context.col end
		vim.api.nvim_buf_set_lines(bufnr, i - 1, -1, false, { v })
		vim.api.nvim_buf_set_extmark(bufnr, harpy, i - 1, 0, { end_col = ind, hl_group = "@keyword.operator" })
		vim.api.nvim_buf_set_extmark(bufnr, harpy, i - 1, ind, { end_col = #v, hl_group = "@comment" })
	end
end

local function move_down(bufnr)
	local l = harpoon:list()
	local ln = vim.fn.getpos(".")[2]
	if ln < l:length() then
		local c = l:get(ln)
		local n = l:get(ln + 1)
		l:replace_at(ln + 1, c)
		l:replace_at(ln, n)
		refresh_buffer(bufnr)
	end
end

local function move_up(bufnr)
	local l = harpoon:list()
	local ln = vim.fn.getpos(".")[2]
	if ln > 1 then
		local c = l:get(ln)
		local n = l:get(ln - 1)
		l:replace_at(ln - 1, c)
		l:replace_at(ln, n)
		refresh_buffer(bufnr)
	end
end

local mark_var = nil
local function move_to(bufnr, ln)
	local l = harpoon:list()
	if mark_var ~= nil then
		local c = l:get(ln)
		local n = l:get(mark_var)
		l:replace_at(mark_var, c)
		l:replace_at(ln, n)
		refresh_buffer(bufnr)
		vim.fn.sign_unplace "Harpoon"
		mark_var = nil
	else
		l:select(ln)
	end
end

local function delete(bufnr)
	local l = harpoon:list()
	local ln = vim.fn.getpos(".")[2]
	l:remove_at(ln)
	refresh_buffer(bufnr)
end

local function select(bufnr)
	local ln = vim.fn.getpos(".")[2]
	if mark_var ~= nil then
		move_to(bufnr, ln)
	else
		local l = harpoon:list()
		l:select(ln)
	end
end

vim.fn.sign_define("mark1", { text = "⇁", texthl = "Type", linehl = "Search" })
local function mark(bufnr)
	if mark_var then
		vim.fn.sign_unplace "Harpoon"
		mark_var = nil
	else
		local ln = vim.fn.getpos(".")[2]
		vim.fn.sign_place(0, "Harpoon", "mark1", bufnr, { lnum = ln })
		mark_var = ln
	end
end

k.set("n", "<C-h>", function()
	-- harpoon:list():display()
	local bufnr = util.menu { { "" }, width = 40, height = 30, title = ">>=====>>", title_pos = "center" }
	vim.cmd("set nonu")
	refresh_buffer(bufnr)
	-- toggle_telescope(harpoon:list())
	local o = { buffer = bufnr, silent = false }
	vim.keymap.set("n", "d", function() move_down(bufnr) end, o)
	vim.keymap.set("n", "u", function() move_up(bufnr) end, o)
	vim.keymap.set("n", "x", function() delete(bufnr) end, o)
	vim.keymap.set("n", "m", function() mark(bufnr) end, o)
	for i = 1, 9 do
		vim.keymap.set("n", "" .. i, function() move_to(bufnr, i) end, o)
	end
	-- vim.keymap.set("n", "<C-1>", function() move_to(bufnr, 1) end, o)
	vim.keymap.set("n", "<CR>", function() select(bufnr) end, o)
end, { desc = "Open harpoon window" })

k.set("n", "<C-S-1>", function() uitl.menu("hello") end)

k.set("n", "<leader>a", function()
	local l = harpoon:list()
	l:add()
	vim.print("" .. l:length())
end)
k.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
-- k.set("n", "<C-e>",":Telescope harpoon marks<CR>")
k.set("n", "<leader>dh", function() harpoon:list():clear() end, { desc = "Del harpoon" })

k.set("n", "m1", function() harpoon:list():replace_at(1) end)
k.set("n", "m2", function() harpoon:list():replace_at(2) end)
wk.add {
	{ "<leader>1", function() harpoon:list():select(1) end, hidden = true },
	{ "<leader>2", function() harpoon:list():select(2) end, hidden = true },
	{ "<leader>3", function() harpoon:list():select(3) end, hidden = true },
	{ "<leader>4", function() harpoon:list():select(4) end, hidden = true },
}

-- k.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- k.set("n", "<C-S-N>", function() harpoon:list():next() end)

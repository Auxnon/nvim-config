local m = {}
-- local colors =
-- 	{ "#caa6f7", "#c1a6f1", "#b9a5ea", "#b1a4e4", "#aba3dc", "#a5a2d4", "#9fa0cc", "#9b9ec4", "#979cbc", "#949ab3" }
require('gitsigns').setup()
local colors = { "#dfaad1", "#af859e", "#7f6370","#504348","#252525"}
vim.api.nvim_set_hl(0, "Hiyo", {
	-- Check the `nvim_set_hl()` help file to see all the available options
	fg = "#CBA6F7",
})
vim.api.nvim_set_hl(0, "White", {
    fg="#FFFFFF",
})

for i, color in ipairs(colors) do
	vim.api.nvim_set_hl(0, "Gradient_" .. i, { fg = color })
end

m.statcol = function()
	return table.concat({
		-- m.folds(),
		-- m.git(),
        "%s%=%",
		m.number(),
		m.border(),
	}, " ")
    -- "%=%s"
end

m.folds = function()
	local foldlevel = vim.fn.foldlevel(vim.v.lnum)
	local foldlevel_before = vim.fn.foldlevel((vim.v.lnum - 1) >= 1 and vim.v.lnum - 1 or 1)
	local foldlevel_after =
		vim.fn.foldlevel((vim.v.lnum + 1) <= vim.fn.line("$") and (vim.v.lnum + 1) or vim.fn.line("$"))

	local foldclosed = vim.fn.foldclosed(vim.v.lnum)

	-- Line has nothing to do with folds so we will skip it
	if foldlevel == 0 then return " " end

	-- Line is a closed fold(I know second condition feels unnecessary but I will still add it)
	if foldclosed ~= -1 and foldclosed == vim.v.lnum then return "▶" end

	-- I didn't use ~= because it couldn't make a nested fold have a lower level than it's parent fold and it's not something I would use
	if foldlevel > foldlevel_before then return "▽" end

	-- The line is the last line in the fold
	if foldlevel > foldlevel_after then return "╰" end

	-- Line is in the middle of an open fold
	return "╎"
end

m.number = function()
	-- return vim.v.lnum;
	return vim.v.relnum == 0 and "%#White#"..vim.v.lnum or vim.v.relnum
end

m.border = function()
	local n = vim.v.relnum
	if n < 5 then
		return "%#Gradient_" .. (n + 1) .. "#│"
	else
		return "%#Gradient_5#│"
	end

	return "%#Hiyo#║"
end

local gitsigns_bar = "▌"

local gitsigns_hl_pool = {
	GitSignsAdd = "DiagnosticOk",
	GitSignsChange = "DiagnosticWarn",
	GitSignsChangedelete = "DiagnosticWarn",
	GitSignsDelete = "DiagnosticError",
	GitSignsTopdelete = "DiagnosticError",
	GitSignsUntracked = "NonText",
}

local function get_sign_name(cur_sign)
	if cur_sign == nil then return nil end

	cur_sign = cur_sign[1]

	if cur_sign == nil then return nil end

	cur_sign = cur_sign.signs

	if cur_sign == nil then return nil end

	cur_sign = cur_sign[1]

	if cur_sign == nil then return nil end

	return cur_sign["name"]
end

local function mk_hl(group, sym) return table.concat({ "%#", group, "#", sym, "%*" }) end

local function get_name_from_group(bufnum, lnum, group)
	local cur_sign_tbl = vim.fn.sign_getplaced(bufnum, {
		group = group,
		lnum = lnum,
	})

	return get_sign_name(cur_sign_tbl)
end

m.get_statuscol_gitsign = function(bufnr, lnum)
	local cur_sign_nm = get_name_from_group(bufnr, lnum, "gitsigns_vimfn_signs_")

	if cur_sign_nm ~= nil then
		return mk_hl(gitsigns_hl_pool[cur_sign_nm], gitsigns_bar)
	else
		return " "
	end
end

m.git = function() return m.get_statuscol_gitsign(0, vim.v.lnum) end

-- With this line we will be able to use myStatuscolumn by requiring this file and calling the function
return m

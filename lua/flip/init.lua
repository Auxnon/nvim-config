local m = {}
m.flip_it = function()
	local word = vim.call("expand", "<cword>")
	-- local out = word:gsub("(%u)", "_%1" ):gsub("(%u)", string.lower):gsub("^_", "")
	local out = m.check(word)
	if out ~= nil then vim.cmd("normal! ciw" .. out) end
end

m.check = function(word)
    -- vim.bo.filetype

	if word == "var" then return "let" end
	if word == "let" then return "const" end
	if word == "const" then return "let" end
	if word == "false" then return "true" end
	if word == "true" then return "false" end
	if word == "0" then return "1" end
	if word == "1" then return "0" end
	if word == ">" then return "<" end
	if word == "<" then return ">" end
	if word == ">=" then return "<=" end
	if word == "<=" then return ">=" end
	if word == "!=" then return "==" end
	if word == "!==" then return "===" end
	if word == "==" then return "!=" end
	if word == "===" then return "!==" end
	return nil
end

return m

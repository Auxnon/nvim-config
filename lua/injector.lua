-- scope_loader.lua
-- A Neovim plugin that uses AI to generate code within the current functional scope

local M = {}

-- Namespace for virtual text
local ns_id = vim.api.nvim_create_namespace("scope_loader")

-- Braille loader patterns (nerdfont)
local loader_frames = {
	"⠋",
	"⠙",
	"⠹",
	"⠸",
	"⠼",
	"⠴",
	"⠦",
	"⠧",
	"⠇",
	"⠏",
}
local frame_idx = 1

-- Timer for animation
local animation_timer = nil
local cleanup_timer = nil

-- Function to get the current scope using treesitter
local function get_current_scope()
	local ts_utils = require("nvim-treesitter.ts_utils")
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1] - 1

	-- Get the current node at cursor
	local node = ts_utils.get_node_at_cursor()
	if not node then return nil end

	-- Traverse up to find a scope node (function, method, class, etc.)
	local scope_types = {
		"function_definition",
		"function_declaration",
		"method_definition",
		"class_definition",
		"block",
		"if_statement",
		"for_statement",
		"while_statement",
		"function_item",
		"impl_item",
		"struct_item",
	}

	local current = node
	while current do
		local node_type = current:type()
		for _, scope_type in ipairs(scope_types) do
			if node_type:match(scope_type) then
				local start_row, start_col, end_row, end_col = current:range()
				return {
					start_row = start_row,
					start_col = start_col,
					end_row = end_row,
					end_col = end_col,
					node = current,
				}
			end
		end
		current = current:parent()
	end

	return nil
end

-- Function to update the loader animation
local function update_loader(bufnr, scope_start, scope_end, start_extmark_id, end_extmark_id, status_text)
	local loader_text = loader_frames[frame_idx] .. " " .. status_text

	-- pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, scope_start, 0, {
	-- 	id = start_extmark_id,
	-- 	virt_text = { { "╭─ " .. loader_text, "DiagnosticInfo" } },
	-- 	virt_text_pos = "eol",
	-- })
	--
	-- pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, scope_end, 0, {
	-- 	id = end_extmark_id,
	-- 	virt_text = { { "╰─ Scope End", "DiagnosticInfo" } },
	-- 	virt_text_pos = "eol",
	-- })

	frame_idx = frame_idx % #loader_frames + 1
end

-- Function to clear all virtual text
local function clear_virtual_text(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

	-- Stop timers
	if animation_timer then
		animation_timer:stop()
		animation_timer:close()
		animation_timer = nil
	end

	if cleanup_timer then
		cleanup_timer:stop()
		cleanup_timer:close()
		cleanup_timer = nil
	end

	-- Reset frame index
	frame_idx = 1
end

-- Function to get context around the scope
local function get_context(bufnr, scope)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local filetype = vim.bo[bufnr].filetype
	local filepath = vim.api.nvim_buf_get_name(bufnr)

	-- Get lines before scope for context (up to 20 lines)
	local context_start = math.max(0, scope.start_row - 20)
	local before_lines = vim.list_slice(lines, context_start + 1, scope.start_row)

	-- Get the scope content
	local scope_lines = vim.list_slice(lines, scope.start_row + 1, scope.end_row + 1)

	-- Get lines after scope for context (up to 20 lines)
	local context_end = math.min(#lines, scope.end_row + 20)
	local after_lines = vim.list_slice(lines, scope.end_row + 2, context_end + 1)

	return {
		before = table.concat(before_lines, "\n"),
		scope = table.concat(scope_lines, "\n"),
		after = table.concat(after_lines, "\n"),
		filetype = filetype,
		filepath = filepath,
		start_line = scope.start_row + 1, -- Convert to 1-indexed
		start_col = scope.start_col,
		end_line = scope.end_row + 1,
		end_col = scope.end_col,
	}
end

-- Function to call OpenCode CLI
local function call_opencode(context, callback)
	local prompt = string.format(
		[[Implement code for the selected scope in %s (lines %d-%d).


Instructions:
- Implement/improve ONLY the code within lines %d-%d
- Return the complete scope including opening/closing braces
- Maintain original indentation
- No explanations or markdown
- Raw code only]],
		context.filepath,
		context.start_line,
		context.end_line,
		-- context.before,
		-- context.start_line,
		-- context.end_line,
		-- context.scope,
		-- context.after,
		context.start_line,
		context.end_line
	)

	-- Context BEFORE (reference only):
	-- ```
	-- %s
	-- ```
	--
	-- SCOPE TO IMPLEMENT (lines %d-%d):
	-- ```
	-- %s
	-- ```
	--
	-- Context AFTER (reference only):
	-- ```
	-- %s
	-- ```

	local cmd = { "opencode", "run", prompt }

	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data and #data > 0 then
				local response = table.concat(data, "\n")
				callback(nil, response)
			end
		end,
		on_stderr = function(_, data)
			if data and #data > 0 and data[1] ~= "" then callback(table.concat(data, "\n"), nil) end
		end,
		on_exit = function(_, exit_code)
			if exit_code ~= 0 then callback("OpenCode CLI failed with exit code: " .. exit_code, nil) end
		end,
	})
end

-- Function to apply the generated code to the scope
local function apply_code_to_scope(bufnr, scope, generated_code)
	-- Split the generated code into lines
	local new_lines = vim.split(generated_code, "\n", { plain = true })

	-- Replace the scope content
	vim.api.nvim_buf_set_lines(bufnr, scope.start_row, scope.end_row + 1, false, new_lines)

	-- Clear the loader
	clear_virtual_text(bufnr)

	vim.notify("Code generated successfully!", vim.log.levels.INFO)
end

-- Main function to generate code
function M.generate_code()
	local bufnr = vim.api.nvim_get_current_buf()

	-- Clear any existing virtual text
	clear_virtual_text(bufnr)

	-- Get the scope
	local scope = get_current_scope()
	if not scope then
		vim.notify("Could not determine scope", vim.log.levels.WARN)
		return
	end

	-- Create initial extmarks at start and end of scope
	local start_extmark_id = vim.api.nvim_buf_set_extmark(bufnr, ns_id, scope.start_row, scope.start_col, {
		-- virt_text = {{'╭─ ' .. loader_frames[1] .. ' Generating code...', 'DiagnosticInfo'}},
		virt_text = { { "╭─ " .. loader_frames[1] .. " Generating code...", "DiagnosticInfo" } },
		virt_text_pos = "overlay",
		virt_lines_above = false,
		-- virt_text_pos = 'eol',
	})

	local end_extmark_id = vim.api.nvim_buf_set_extmark(bufnr, ns_id, scope.end_row, scope.end_col, {
		-- virt_text = {{'╰─ Scope End', 'DiagnosticInfo'}},
		virt_text = { { "╰─ Scope End", "DiagnosticInfo" } },
		virt_text_pos = "overlay",

		virt_lines_above = false,
		-- virt_text_pos = 'eol',
	})

	-- Start animation
	animation_timer = vim.loop.new_timer()
	animation_timer:start(
		80,
		80,
		vim.schedule_wrap(
			function()
				update_loader(
					bufnr,
					scope.start_row,
					scope.end_row,
					start_extmark_id,
					end_extmark_id,
					"Generating code..."
				)
			end
		)
	)

	cleanup_timer = vim.loop.new_timer()
	cleanup_timer:start(2000, 0, vim.schedule_wrap(function() clear_virtual_text(bufnr) end))

	-- Get context
	local context = get_context(bufnr, scope)

	-- Call OpenCode CLI
	-- call_opencode(context, function(err, generated_code)
	-- 	vim.schedule(function()
	-- 		if err then
	-- 			clear_virtual_text(bufnr)
	-- 			vim.notify("Error: " .. err, vim.log.levels.ERROR)
	-- 			return
	-- 		end
	--
	-- 		if not generated_code or generated_code == "" then
	-- 			clear_virtual_text(bufnr)
	-- 			vim.notify("No code generated", vim.log.levels.WARN)
	-- 			return
	-- 		end
	--
	-- 		-- Apply the generated code
	-- 		apply_code_to_scope(bufnr, scope, generated_code)
	-- 	end)
	-- end)
end

-- Setup function
function M.setup(opts)
	opts = opts or {}

	-- Create the keybinding
	vim.keymap.set(
		"n",
		"<leader>cc",
		function() M.generate_code() end,
		{ desc = "Generate code in current scope", silent = true }
	)
end

return M

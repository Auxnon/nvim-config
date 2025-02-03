-- Utilities for creating configurations
local util = require("formatter.util")

local function get_path() return util.escape_path(util.get_current_buffer_file_path()) end

function format_prettier()
	return {
		exe = "npx",
		args = { "prettier", "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
		stdin = true,
	}
end

function mix()
	return {
		exe = "mix",
		args = { "format", "-" },
		stdin = true,
	}
end

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,

			-- You can also define your own configuration
			function()
				-- Supports conditional formatting
				-- if util.get_current_buffer_file_name() == "special.lua" then
				--   return nil
				-- end

				-- Full specification of configurations is down below and in Vim help
				-- files
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						-- "--config-path",
						-- get_path(),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},
		nix = {
			require("formatter.filetypes.nix"),
			function()
				return {
					exe = "nixpkgs-fmt",
					-- args={
					--     get_path()
					-- },
					stdin = true,
				}
			end,
		},
		javascript = {
			format_prettier,
		},
		typescript = {
			format_prettier,
		},
		javascriptreact = {
			format_prettier,
		},
		typescriptreact = {
			format_prettier,
		},
		html = {
			format_prettier,
		},
		scss = {
			format_prettier,
		},
		elixir = {
			mix,
		},
		heex = {
			mix,
		},
		eex = {
			mix,
		},

		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

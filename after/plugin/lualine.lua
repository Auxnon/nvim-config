local cyberdream = require("lualine.themes.cyberdream") -- or require("lualine.themes.cyberdream-light") for the light variant

require("lualine").setup {
	options = {
		icons_enabled = true,
		theme = "cyberdream",
		component_separators = { left = " ", right = "󰳝 " }, -- 
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { --"mode"
			{
				function()
					-- Fetches the tail (name) of the root working directory
					local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

					-- Truncate and add ellipsis if it exceeds 16 characters
					if string.len(dir) > 24 then return string.sub(dir, 1, 21) .. "..." end

					return dir
				end,
				-- icon = "💼",
			},
		},
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", icon = "󰈤 " } },
        -- lualine_x={},
		lualine_x = {
			-- "encoding",
			"filetype",
			{
				"hostname",
				fmt = function(str)
					if str:find("^Nick", 1) ~= nil then return "🍎" end
					return string.match(str, "^[^%.]+")
				end,
			},
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		-- lualine_b = {},
		lualine_c = { "filename" },
		-- lualine_x = {
  --           "filetype",
		-- 	"hostname",
		-- },
		-- lualine_y = { "location" },
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
}

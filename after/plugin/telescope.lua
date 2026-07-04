local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {desc="Fuzzy find"})
-- vim.keymap.set('n', '<C-l>', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc="Git fuzzy find"})
----vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
----vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
---- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

function get_visual()
  local _, ls, cs = unpack(vim.fn.getpos('v'))
  local _, le, ce = unpack(vim.fn.getpos('.'))
  return vim.api.nvim_buf_get_text(0, ls-1, cs-1, le-1, ce, {})
end

local grepper =function()
	builtin.grep_string({ search=vim.fn.input "Grep > " });
end

local vgrep=function()
    local v=get_visual()[1]
    -- vim.api.nvim_echo({{"we good" }}, false, {})
    -- require("notify")("we got " .. v)
	builtin.grep_string { search=v}
end

vim.keymap.set('n', '<leader>ps', grepper, {desc="Grep search"})
vim.keymap.set('n', '<C-l>', grepper, {desc="Grep search"})
vim.keymap.set('v', '<C-l>', vgrep, {desc="Visual grep search"})

-- vim.keymap.set("n", "<space>pb", ":Telescope file_browser<CR>")


vim.keymap.set("n", "<leader>pb", function()
  -- Dynamically get the directory of the current active buffer
  local current_dir = vim.fn.expand("%:p:h")
  
  -- Fallback to current working directory if the buffer has no valid path
  if current_dir == "" then
    current_dir = vim.fn.getcwd()
  end

  -- Launch telescope-file-browser as a sidebar
  require("telescope").extensions.file_browser.file_browser({
    path = current_dir,       -- Start browsing from current buffer's path
    cwd_to_path = true,       -- Set local path as the current scope
    grouped = true,           -- Keep folders grouped above files
    hide_parent_dir = true,   -- Hide the default `../` to keep UI clean
    sorting_strategy = "ascending", -- Put the search prompt at the top

    -- Force the layout to simulate a side panel
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        width = 40,           -- Fixed sidebar width (columns)
        height = vim.o.lines, -- Span the entire vertical screen height
        prompt_position = "top",
        preview_height = 0,   -- Disable the code preview to save space
      },
      anchor = "NW",          -- Snap the window to the Northwest (Top-Left)
    },
    
    -- Optional: Use a borderless theme or minimal style
    theme = "ivy", -- You can try "dropdown" or omit to use default borders
  })
end, { desc = "File browser side panel (Current Buffer)" })




vim.api.nvim_set_hl(0, "OilPillText", { fg = "#11111b", bg = "#89b4fa", bold = true }) -- Dark text on blue pill
vim.api.nvim_set_hl(0, "OilPillEdge", { fg = "#89b4fa" }) -- Matches the pill color to blend perfectly

local function update_oil_border_winbar()
  if vim.bo.filetype == "oil" then
    local oil = require("oil")
    local dir = oil.get_current_dir()
    if dir then
      -- Left edge  , Middle Text, Right edge 
      vim.wo.winbar = " %#OilPillEdge#%#OilPillText# " .. dir .. " %#OilPillEdge#"
    end
  end
end

vim.api.nvim_create_autocmd("FileType", { pattern = "oil", callback = update_oil_border_winbar })
vim.api.nvim_create_autocmd("User", { pattern = "OilActionsPost", callback = update_oil_border_winbar })



local function open_oil_side_panel()
  -- 1. Grab the directory of the CURRENT active file before we split
  local current_file_dir = vim.fn.expand("%:p:h")
  
  -- If it's an empty or special buffer, default to the current working directory
  if current_file_dir == "" or vim.bo.buftype ~= "" then
    current_file_dir = vim.fn.getcwd()
  end

  -- 2. Save the window ID of our original code editor window
  local original_win = vim.api.nvim_get_current_win()

  -- 3. Open the split cleanly on the far left
  vim.cmd("topleft vsplit")
  vim.cmd("vertical resize 30")
  vim.cmd("enew")
  
  -- Force a screen redraw to fix the broken/cut-off UI gutter
  vim.cmd("redraw")

  -- 4. Open Oil explicitly in the directory we grabbed in step 1
  require("oil").open(current_file_dir)

  -- 5. Map the Enter key inside THIS specific Oil buffer to open in the original window
  vim.keymap.set("n", "<CR>", function()
    -- Get the entry under the cursor
    local entry = require("oil").get_cursor_entry()
    if not entry then return end

    -- If it's a directory, let Oil handle it normally (do nothing special)
    if entry.type == "directory" then
      require("oil").actions.select.callback()
      return
    end

    -- If it's a file, get its full path
    local dir = require("oil").get_current_dir()
    local file_path = dir .. entry.name

    -- Close the Oil sidebar panel (optional, remove this line if you want it to stay open)
    vim.cmd("close")

    -- Switch back focus to our original code window and edit the file
    if vim.api.nvim_win_is_valid(original_win) then
      vim.api.nvim_set_current_win(original_win)
      vim.cmd("edit " .. vim.fn.fnameescape(file_path))
    end
  end, { buffer = true, silent = true, desc = "Open file in original window" })
end

-- vim.keymap.set("n", "<leader>pp", "<CMD>:vsplit | vertical resize 30 | enew | lua require('oil').open()<CR>", { desc = "Split oil" })
vim.keymap.set("n", "<leader>pp", open_oil_side_panel, { desc = "Oil side" })

-- local actions = require("telescope.actions")
local open_with_trouble = require("trouble.sources.telescope").open

-- Use this to add more results without clearing the trouble list
-- local add_to_trouble = require("trouble.sources.telescope").add

local telescope = require("telescope")

telescope.setup({
  defaults = {
    mappings = {
      i = { ["<c-t>"] = open_with_trouble },
      n = { ["<c-t>"] = open_with_trouble },
    },
  },
})

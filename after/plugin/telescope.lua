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

vim.keymap.set('n', '<leader>ps', grepper)
vim.keymap.set('n', '<C-l>', grepper)
vim.keymap.set('v', '<C-l>', vgrep)

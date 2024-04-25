local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {desc="Fuzzy find"})
-- vim.keymap.set('n', '<C-l>', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc="Git fuzzy find"})
----vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
----vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
---- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
local grepper =function()
	builtin.grep_string ({ search=vim.fn.input "Grep > " });
end
vim.keymap.set('n', '<leader>ps', grepper)
vim.keymap.set('n', '<C-l>', grepper)

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
-- vim.keymap.set("n", "K", function() vim.lsp.inlay_hint.enable(true) end, opts)
vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, opts)
vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
vim.keymap.set("n", "<C-f>", vim.cmd.Format)
vim.keymap.set("n", "<leader>sr", ":%s/<C-r>0//g<Left><Left>", {desc="Replace all instances of clipboard in text"})
vim.keymap.set("v", "<leader>sr", "y:%s/<C-r>0//g<Left><Left>", {desc="Replace all instances of text selection"})
vim.keymap.set("n", "<leader>sR", function()
    local old_word = vim.fn.expand "<cword>"
    local new_word = vim.fn.input("Replace " .. old_word .. " by? ", old_word)
    -- Check if the new_word is different from the old_word and is not empty
    if new_word ~= old_word and new_word ~= "" then
      vim.cmd(":%s/\\<" .. old_word .. "\\>/" .. new_word .. "/g")
    end
end)

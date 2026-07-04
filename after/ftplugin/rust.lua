vim.keymap.set("n", "<C-f>", "<CMD>:RustFmt<CR>", { desc = "Rust format" })

local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set("n", "<leader>ca", function()
	vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
	-- or vim.lsp.buf.codeAction() if you don't want grouping.
end, { silent = true, buffer = bufnr })
vim.keymap.set(
	"n",
	"K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
	function() vim.cmd.RustLsp({ "hover", "actions" }) end,
	{ silent = true, buffer = bufnr }
)


vim.g.rustaceanvim = {
  server = {
    settings = {
      ["rust-analyzer"] = {
        hover = {
          memoryLayout = {
            enable = true,    -- Enables the overall memory layout info
            size = "bytes",   -- Displays size in bytes (can also be "bits")
            alignment = true, -- Shows alignment constraints
            niches = true,     -- Shows available niches for optimization
          },
        },
      },
    },
  },
}

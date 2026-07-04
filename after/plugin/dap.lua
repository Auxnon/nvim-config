local dap = require("dap")
local dapui = require("dapui")

-- Auto-install the JS debug adapter (vscode-js-debug) via Mason.
-- This provides the "pwa-node" and "pwa-chrome" adapters used below.
require("mason-nvim-dap").setup({
	ensure_installed = { "js" },
	automatic_installation = true,
	handlers = {}, -- we define the adapters/configs manually below
})

dapui.setup()
require("nvim-dap-virtual-text").setup({})

-- Open/close the UI automatically alongside a debug session.
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

-- Pretty breakpoint signs
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual", numhl = "" })

--------------------------------------------------------------------------------
-- Adapters (vscode-js-debug, installed by mason as "js-debug-adapter")
--------------------------------------------------------------------------------
local js_debug = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter"

for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "node-terminal" }) do
	dap.adapters[adapter] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = js_debug,
			args = { "${port}" },
		},
	}
end

--------------------------------------------------------------------------------
-- Configurations for Node.js / NestJS / Next.js
--------------------------------------------------------------------------------
local skip = { "<node_internals>/**", "node_modules/**" }

-- Prompt for the inspector port (defaults to 9229). NOTE: this is the Node
-- *debugger* port (from --inspect), NOT your app's HTTP port (e.g. 3001).
local function inspector_port() return tonumber(vim.fn.input("Inspector port: ", "9229")) end

local configs = {
	-------------------------------------------------- Node.js
	{
		type = "pwa-node",
		request = "launch",
		name = "Node: Launch current file",
		program = "${file}",
		cwd = "${workspaceFolder}",
		runtimeExecutable = "node",
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
		skipFiles = skip,
	},
	{
		type = "pwa-node",
		request = "attach",
		name = "Node: Attach to process",
		processId = require("dap.utils").pick_process,
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		skipFiles = skip,
	},
	{
		type = "pwa-node",
		request = "attach",
		name = "Node: Attach to inspector port",
		address = "localhost",
		port = inspector_port,
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		restart = true,
		skipFiles = skip,
	},
	{
		type = "pwa-node",
		request = "attach",
		name = "Attach to Bun",
		port = 9229,
		webRoot = "${workspaceFolder}",
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		skipFiles = skip,
		websocketAddress = function() return vim.fn.input("Paste Bun WebSocket URL: ") end,
	},
	-------------------------------------------------- NestJS
	-- Launches `npm run start:debug` (nest start --debug --watch) and attaches.
	{
		type = "pwa-node",
		request = "launch",
		name = "NestJS: Launch (npm start)",
		runtimeExecutable = "npm",
		runtimeArgs = { "start" },
		cwd = "${workspaceFolder}",
		console = "integratedTerminal",
		autoAttachChildProcesses = true,
		restart = true,
		sourceMaps = true,
		skipFiles = skip,
	},
	-- For when you already have `nest start --debug` running (port 9229).
	{
		type = "pwa-node",
		request = "attach",
		name = "NestJS: Attach (inspector port)",
		address = "localhost",
		port = inspector_port,
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		restart = true,
		skipFiles = skip,
	},
	-------------------------------------------------- Next.js
	-- Server-side: launches the dev server and attaches to its node process.
	{
		type = "pwa-node",
		request = "launch",
		name = "Next.js: Launch dev (server-side)",
		runtimeExecutable = "npm",
		runtimeArgs = { "run", "dev" },
		cwd = "${workspaceFolder}",
		console = "integratedTerminal",
		autoAttachChildProcesses = true,
		sourceMaps = true,
		skipFiles = skip,
	},
	-- Server-side attach (run `NODE_OPTIONS='--inspect' next dev` yourself first).
	{
		type = "pwa-node",
		request = "attach",
		name = "Next.js: Attach server-side (inspector port)",
		address = "localhost",
		port = inspector_port,
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		restart = true,
		skipFiles = skip,
	},
	-- Client-side: debug the browser via Chrome (needs `next dev` running on :3000).
	{
		type = "pwa-chrome",
		request = "launch",
		name = "Next.js: Debug client-side (Chrome)",
		url = "http://localhost:3000",
		webRoot = "${workspaceFolder}",
		sourceMaps = true,
		userDataDir = false,
	},
}

for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
	dap.configurations[lang] = configs
end

--------------------------------------------------------------------------------
-- Keymaps  (<leader>b -> "Debug" group; function keys for stepping)
--------------------------------------------------------------------------------
local k = vim.keymap.set
k("n", "<F5>", function() dap.continue() end, { desc = "Debug: continue / start" })
k("n", "<F10>", function() dap.step_over() end, { desc = "Debug: step over" })
k("n", "<F11>", function() dap.step_into() end, { desc = "Debug: step into" })
k("n", "<F12>", function() dap.step_out() end, { desc = "Debug: step out" })

k("n", "<leader>br", function() dap.continue() end, { desc = "Run / continue" })
k("n", "<leader>bb", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
k(
	"n",
	"<leader>bc",
	function() dap.set_breakpoint(vim.fn.input("Condition: ")) end,
	{ desc = "Conditional breakpoint" }
)
k("n", "<leader>bl", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log message: ")) end, { desc = "Log point" })
k("n", "<leader>bo", function() dap.step_over() end, { desc = "Step over" })
k("n", "<leader>bi", function() dap.step_into() end, { desc = "Step into" })
k("n", "<leader>be", function() dap.step_out() end, { desc = "Step out (exit)" })
k("n", "<leader>bn", function() dap.run_last() end, { desc = "Run last" })
k("n", "<leader>bt", function() dap.terminate() end, { desc = "Terminate" })
k("n", "<leader>bp", function() dap.repl.toggle() end, { desc = "REPL toggle" })
k("n", "<leader>bu", function() dapui.toggle() end, { desc = "Toggle UI" })
k("n", "<leader>bh", function() require("dap.ui.widgets").hover() end, { desc = "Hover value" })

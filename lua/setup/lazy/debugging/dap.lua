return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"mfussenegger/nvim-dap-python",
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Mirrors neotest-python's ".venv/bin/python" convention in lazy/debugging/neotest.lua.
		-- venv-selector.lua's on_venv_activate_callback re-runs this setup when the user switches venvs.
		local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
		if vim.uv.fs_stat(venv_python) then
			require("dap-python").setup(venv_python)
		else
			require("dap-python").setup("python3")
		end

		dapui.setup()
		require("nvim-dap-virtual-text").setup()

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
	end,
	keys = {
		{ "<leader>b", "", desc = "+debug" },
		{ "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
		{ "<F6>", function() require("dap").pause() end, desc = "Debug: Pause" },
		{ "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
		{ "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
		{ "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
		{ "<leader>bb", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
		{ "<leader>bc", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
		{ "<leader>bl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: ")) end, desc = "Log Point" },
		{ "<leader>br", function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" },
		{ "<leader>bt", function() require("dap").terminate() end, desc = "Terminate" },
		{ "<leader>bR", function() require("dap").run_last() end, desc = "Run Last" },
		{ "<leader>bu", function() require("dapui").toggle() end, desc = "Toggle Debug UI" },
		{ "<leader>be", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Evaluate Expression" },
	},
}

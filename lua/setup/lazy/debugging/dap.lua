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

		-- Host the debugpy adapter from Mason's dedicated debugpy venv so individual project
		-- venvs don't each need `pip install debugpy`. Resolve the target script's interpreter
		-- dynamically from venv-selector -> $VIRTUAL_ENV -> .venv/bin/python -> python3.
		local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
		local adapter_python = vim.uv.fs_stat(mason_debugpy) and mason_debugpy or "python3"
		local dap_python = require("dap-python")
		dap_python.setup(adapter_python)
		dap_python.resolve_python = function()
			local ok_vs, vs = pcall(require, "venv-selector")
			if ok_vs and vs.python() and vs.python() ~= "" then
				return vs.python()
			end
			if vim.env.VIRTUAL_ENV and vim.uv.fs_stat(vim.env.VIRTUAL_ENV .. "/bin/python") then
				return vim.env.VIRTUAL_ENV .. "/bin/python"
			end
			local cwd_venv = vim.fn.getcwd() .. "/.venv/bin/python"
			if vim.uv.fs_stat(cwd_venv) then
				return cwd_venv
			end
			return "python3"
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
		{ "<F5>", function() require("dap").continue() end, desc = "Debug: Continue / Start" },
		{ "<F6>", function() require("dap").pause() end, desc = "Debug: Pause" },
		{ "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
		{ "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
		{ "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
		{ "<leader>bb", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
		{ "<leader>bc", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
		{ "<leader>bl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: ")) end, desc = "Log Point" },
		{ "<leader>br", function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" },
		{ "<leader>bt", function() require("dap").terminate() end, desc = "Terminate Session" },
		{ "<leader>bR", function() require("dap").run_last() end, desc = "Run Last Session" },
		{ "<leader>bu", function() require("dapui").toggle() end, desc = "Toggle Debug UI" },
		{ "<leader>be", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Evaluate Expression" },
		{ "<leader>bm", function() require("dap-python").test_method() end, ft = "python", desc = "Debug Python Test Method" },
		{ "<leader>bC", function() require("dap-python").test_class() end, ft = "python", desc = "Debug Python Test Class" },
	},
}

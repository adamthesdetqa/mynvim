return {
	"linux-cultist/venv-selector.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	ft = { "python" },
	opts = {
		options = {
			-- Defaults to true, which reassigns vim.notify to the raw nvim-notify plugin
			-- table, stomping on Noice's own management of vim.notify.
			override_notify = false,
			-- Syncs dap-python, neotest-python, and jupynvim whenever a venv is activated.
			on_venv_activate_callback = function()
				local venv_python = require("venv-selector").python()
				if not venv_python or venv_python == "" then
					return
				end

				local ok_dap, dap_python = pcall(require, "dap-python")
				if ok_dap then
					dap_python.resolve_python = function()
						return venv_python
					end
				end

				local ok_neotest, neotest = pcall(require, "neotest")
				if ok_neotest then
					-- Keep this adapter list in sync with lazy/debugging/neotest.lua if it changes.
					neotest.setup({
						adapters = {
							require("neotest-vitest"),
							require("neotest-jest")({
								jestCommand = "pnpm test",
								env = { CI = true },
								cwd = function()
									return vim.fn.getcwd()
								end,
							}),
							require("neotest-python")({ runner = "pytest", python = venv_python }),
						},
					})
				end

				local ok_jupy, jupynvim = pcall(require, "jupynvim")
				if ok_jupy and jupynvim.config then
					jupynvim.config.python = venv_python
				end

				vim.notify("Synced dap-python/neotest/jupynvim to " .. venv_python, vim.log.levels.INFO, { title = "VenvSelect" })
			end,
		},
	},
	keys = {
		{ "<leader>vs", "<cmd>VenvSelect<CR>", ft = { "python" }, desc = "Select Python Venv" },
		{ "<leader>vc", "<cmd>VenvSelectCached<CR>", ft = { "python" }, desc = "Restore Cached Python Venv" },
	},
}

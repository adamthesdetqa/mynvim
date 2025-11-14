return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-neotest/nvim-nio",
		"nvim-treesitter/nvim-treesitter",
		"haydenmeade/neotest-jest", -- Jest adapter for Angular
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = "pnpm test", -- Uses Angular CLI
					env = { CI = true },
					cwd = function()
						return vim.fn.getcwd()
					end,
				}),
			},
			-- Use custom command for Karma
			consumers = {
				karma = function(client)
					client.run = function(file)
						-- Run the specific test file using Karma CLI
						local cmd = "ng test --browsers=ChromeHeadless --watch=false --include=" .. file
						vim.fn.jobstart(cmd, { stdout_buffered = true })
					end
				end,
			},
			status = { virtual_text = true },
			output = { open_on_run = true },
		})
	end,
	keys = {
		{ "<leader>l", "", desc = "+test" },
		{
			"<leader>ll",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run File",
		},
		{
			"<leader>lT",
			function()
				require("neotest").run.run(require("utils.path").current_project_root())
			end,
			desc = "Run Project",
		},
		{
			"<leader>lA",
			function()
				require("neotest").run.run(vim.uv.cwd())
			end,
			desc = "Run All",
		},
		{
			"<leader>lr",
			function()
				require("neotest").run.run()
			end,
			desc = "Run Nearest",
		},
		{
			"<leader>ll",
			function()
				require("neotest").run.run_last()
			end,
			desc = "Run Last",
		},
		{
			"<leader>ls",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle Summary",
		},
		{
			"<leader>lo",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "Show Output",
		},
		{
			"<leader>lO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Toggle Output Panel",
		},
		{
			"<leader>lS",
			function()
				require("neotest").run.stop()
			end,
			desc = "Stop",
		},
		{
			"<leader>lw",
			function()
				require("neotest").watch.toggle(vim.fn.expand("%"))
			end,
			desc = "Toggle Watch",
		},
		{
			"<leader>lu",
			function()
				require("neotest").run.run({ jest = { args = { "--updateSnapshot" } } })
			end,
			desc = "Update Jest Snapshots",
		},
	},
}

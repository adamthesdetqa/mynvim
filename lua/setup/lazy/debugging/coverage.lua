return {
	"andythigpen/nvim-coverage",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = {
		"Coverage",
		"CoverageSummary",
		"CoverageLoad",
		"CoverageShow",
		"CoverageHide",
		"CoverageClear",
		"CoverageToggle",
	},
	keys = {
		{ "<leader>lc", "<cmd>CoverageToggle<CR>", desc = "Toggle Coverage Signs" },
		{
			"<leader>lC",
			function()
				require("coverage").load(true)
			end,
			desc = "Load & Show Coverage",
		},
		{ "<leader>ly", "<cmd>CoverageSummary<CR>", desc = "Coverage Summary" },
	},
	config = function()
		require("coverage").setup({
			auto_reload = true,
			lang = {
				javascript = { -- Works for TypeScript too
					coverage_file = "cov/lcov.info",
					project_root = function(filename)
						return filename:gsub("^ng%-client/", "")
					end,
				},
			},
		})
	end,
}

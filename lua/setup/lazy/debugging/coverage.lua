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
	config = function()
		require("coverage").setup({
			-- commands = true, -- create commands
			-- highlights = {
			-- 	covered = { fg = "#C3E88D" }, -- Green for covered lines
			-- 	uncovered = { fg = "#F07178" }, -- Red for uncovered lines
			-- },
			-- signs = {
			-- 	covered = { hl = "CoverageCovered", text = "▎" },
			-- 	uncovered = { hl = "CoverageUncovered", text = "▎" },
			-- },
			-- summary = {
			-- 	min_coverage = 80.0, -- Minimum coverage threshold (for highlighting)
			-- },
			lang = {
				javascript = { -- Works for TypeScript too
					coverage_file = "cov/lcov.info",
					project_root = function(filename)
						return filename:gsub("^ng%-client/", "")
					end,
				},
			},
		})

		-- Keybindings for convenience
		-- vim.keymap.set("n", "<leader>cl", ":CoverageLoad<CR>", { desc = "Load coverage" })
		-- vim.keymap.set("n", "<leader>cs", ":CoverageShow<CR>", { desc = "Show coverage" })
		-- vim.keymap.set("n", "<leader>ch", ":CoverageHide<CR>", { desc = "Hide coverage" })
		-- vim.keymap.set("n", "<leader>cc", ":CoverageSummary<CR>", { desc = "Show coverage summary" })
	end,
}

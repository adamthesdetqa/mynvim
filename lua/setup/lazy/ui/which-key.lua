return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		preset = "modern",
		delay = 200,
		win = {
			border = "rounded",
			padding = { 1, 2 },
		},
		spec = {
			-- Top-level leader groups (all languages)
			{ "<leader>b", group = "Debug (DAP)", icon = " " },
			{ "<leader>c", group = "Code (LSP & Mason)", icon = " " },
			{ "<leader>f", group = "Find (Telescope)", icon = " " },
			{ "<leader>g", group = "Goto (LSP)", icon = "󰈮 " },
			{ "<leader>h", group = "Git Hunks (Gitsigns)", icon = " ", mode = { "n", "v" } },
			{ "<leader>j", group = "Jupyter / Molten", icon = " ", mode = { "n", "v" } },
			{ "<leader>l", group = "Test & Coverage (Neotest)", icon = "󰙨 " },
			{ "<leader>L", group = "Live Server", icon = "󰖟 " },
			{ "<leader>m", group = "Format & Markdown", icon = "󰉼 ", mode = { "n", "v" } },
			{ "<leader>n", group = "Notifications & Highlights", icon = "󰂚 " },
			{ "<leader>o", group = "Open Tools (Database)", icon = " " },
			{ "<leader>r", group = "Run / Refactor / Reload", icon = " " },
			{ "<leader>s", group = "Splits & Windows", icon = " " },
			{ "<leader>t", group = "Tabs", icon = "󰓩 " },
			{ "<leader>v", group = "VirtualEnv (Python)", icon = " " },
			{ "<leader>x", group = "Diagnostics & Trouble", icon = " " },
			{ "<leader>z", group = "Folds (UFO)", icon = " " },

			-- Single-key leader actions with clear labels
			{ "<leader>a", desc = "Swap Next Parameter (Treesitter)", icon = "󰓡 " },
			{ "<leader>A", desc = "Swap Prev Parameter (Treesitter)", icon = "󰓡 " },
			{ "<leader>d", desc = "Line Diagnostics (Float)", icon = " " },
			{ "<leader>D", desc = "Buffer Diagnostics (Telescope)", icon = " " },
			{ "<leader>e", desc = "File Explorer (Neo-tree)", icon = "󰙅 " },
			{ "<leader>+", desc = "Increment Number", icon = " " },
			{ "<leader>-", desc = "Decrement Number", icon = " " },

			-- Non-leader prefix groups for discoverability
			{ "[", group = "Prev (Diagnostic / Hunk / Func / Cell)" },
			{ "]", group = "Next (Diagnostic / Hunk / Func / Cell)" },
			{ "g", group = "Goto (Definition / References / Type)" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = true })
			end,
			desc = "Show All Keymaps (Which-Key)",
		},
	},
}

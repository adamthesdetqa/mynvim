return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "codecompanion", "copilot-chat" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>md", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle markdown rendering" },
	},
	opts = {
		-- reveal the raw text of whatever line the cursor is on
		anti_conceal = { enabled = true },
		heading = {
			sign = false,
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
		},
		code = {
			sign = false,
			width = "block",
			right_pad = 2,
		},
		checkbox = {
			unchecked = { icon = "󰄱 " },
			checked = { icon = "󰱒 " },
		},
	},
}

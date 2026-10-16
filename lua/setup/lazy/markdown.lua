return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "quarto" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>md", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle markdown rendering" },
	},
	opts = {
		-- explicit, since the plugin's own default (file_types = {"markdown"}) would otherwise
		-- skip quarto-nvim's .qmd buffers (filetype=quarto), which is what jupytext.nvim now
		-- pairs python .ipynb notebooks to -- see lazy/langs/python.lua and lazy/langs/quarto.lua
		file_types = { "markdown", "quarto" },
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

return {
	{
		"quarto-dev/quarto-nvim",
		ft = "quarto",
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("quarto").setup({
				lspFeatures = {
					enabled = true,
					chunks = "curly", -- expects jupytext's "{python}" chunk fences
					languages = { "python" },
				},
				codeRunner = {
					enabled = true,
					default_method = "molten", -- reuses the kernel from lazy/langs/python.lua
				},
			})

			-- mapleader and maplocalleader are both set to <space> in this config, so quarto's
			-- own README-suggested <localleader>r* keymaps would collide with existing <leader>r*
			-- bindings (e.g. <leader>rc reloads config). Stay under the established <leader>j*
			-- "+jupyter" prefix instead, buffer-local so it only applies inside quarto buffers.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "quarto",
				callback = function(args)
					local runner = require("quarto.runner")
					local map_opts = { buffer = args.buf, silent = true }
					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", map_opts, { desc = desc }))
					end

					map("n", "<leader>jc", runner.run_cell, "Run Cell")
					map("n", "<leader>ja", runner.run_above, "Run Cell and Above")
					map("n", "<leader>jA", runner.run_all, "Run All Cells")
					map("n", "<leader>jl", runner.run_line, "Run Line")
					map("v", "<leader>jv", runner.run_range, "Run Visual Range")
					map("n", "]j", "/^```{<CR>", "Next Cell")
					map("n", "[j", "?^```{<CR>", "Previous Cell")
				end,
			})
		end,
	},
	{
		"jmbuhr/otter.nvim",
		lazy = true,
		opts = {},
	},
}

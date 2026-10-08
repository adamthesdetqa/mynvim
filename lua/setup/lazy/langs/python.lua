return {
	{
		"3rd/image.nvim",
		lazy = true,
		opts = {
			backend = "kitty", -- Ghostty/modern WezTerm support the Kitty graphics protocol;
			-- run `:checkhealth image` after install and switch to "sixel" if rendering is broken
			processor = "magick_cli", -- requires ImageMagick (see prerequisites)
			integrations = {},
			max_width_window_percentage = 80,
			max_height_window_percentage = 80,
		},
	},
	{
		"GCBallesteros/jupytext.nvim",
		lazy = false, -- must load before any .ipynb is read
		opts = {
			style = "percent",
			output_extension = "auto",
			force_ft = "python",
			-- Overrides the style above for python-kernel notebooks specifically: pairs
			-- .ipynb to .qmd with `{python}` curly chunk fences (Quarto's native syntax)
			-- instead of "# %%" comments, so quarto-nvim/otter.nvim (lazy/langs/quarto.lua)
			-- get rendered-markdown cells + per-chunk LSP. jupytext keys this by kernel
			-- language, not by file, so this applies to every python .ipynb uniformly.
			custom_language_formatting = {
				python = {
					extension = "qmd",
					style = "quarto",
					force_ft = "quarto", -- required for otter.nvim/quarto-nvim to activate
				},
			},
		},
	},
	{
		"benlubas/molten-nvim",
		dependencies = { "3rd/image.nvim" },
		build = ":UpdateRemotePlugins",
		ft = { "python", "quarto" }, -- jupytext now presents .ipynb buffers as filetype=quarto
		init = function()
			vim.g.molten_image_provider = "image.nvim"
			-- virt_text_output=true (the previous setting) specifically suppresses the floating
			-- output window from auto-opening, replacing it with virtual text -- which isn't real
			-- buffer content, so it can't be selected/yanked and only showed once you scrolled to
			-- it. auto_open_output=true + virt_text_output=false instead pops a real (yankable)
			-- floating window right below the cell as soon as the cursor is in it.
			vim.g.molten_auto_open_output = true
			vim.g.molten_wrap_output = true
			vim.g.molten_virt_text_output = false
			vim.g.molten_output_win_max_height = 20
		end,
		keys = {
			{ "<leader>j", "", desc = "+jupyter" },
			{ "<leader>ji", "<cmd>MoltenInit<CR>", desc = "Init Molten Kernel" },
			-- Evaluate line/operator/visual remain useful for plain .py scripts (no chunks).
			-- Inside quarto-filetype notebooks, lazy/langs/quarto.lua's FileType autocmd
			-- shadows <leader>jl/<leader>jv buffer-locally with quarto's chunk-aware runner,
			-- and adds <leader>jc/ja/jA for cell-based execution (there's no more "# %%"-based
			-- cell here now that notebooks pair to .qmd chunks instead).
			{ "<leader>jl", "<cmd>MoltenEvaluateLine<CR>", desc = "Evaluate Line" },
			{ "<leader>je", "<cmd>MoltenEvaluateOperator<CR>", desc = "Evaluate Operator" },
			{ "<leader>jv", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", desc = "Evaluate Visual Selection" },
			{ "<leader>jo", "<cmd>noautocmd MoltenEnterOutput<CR>", desc = "Enter Output Window" },
			{ "<leader>jy", "<cmd>MoltenYankOutput!<CR>", desc = "Yank Output to Clipboard" },
			{ "<leader>jh", "<cmd>MoltenHideOutput<CR>", desc = "Hide Output" },
			{ "<leader>jd", "<cmd>MoltenDelete<CR>", desc = "Delete Cell Output" },
			{ "<leader>jr", "<cmd>MoltenRestart<CR>", desc = "Restart Kernel" },
			{ "<leader>jq", "<cmd>MoltenDeinit<CR>", desc = "Stop Molten (buffer)" },
		},
	},
}

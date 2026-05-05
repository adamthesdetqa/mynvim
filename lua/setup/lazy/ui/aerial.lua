return {
	"stevearc/aerial.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("aerial").setup({
			keymaps = {
				["l"] = "actions.prev",
				["k"] = "actions.next",
				[";"] = "actions.jump",
				["j"] = "actions.tree_close",
			},
			-- optionally use on_attach to set keymaps when aerial has attached to a buffer
			on_attach = function(bufnr)
				-- Jump forwards/backwards with '{' and '}'
				vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
				vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
			end,
		})
		-- Keymap to toggle the sidebar
		vim.keymap.set("n", "<leader>lo", "<cmd>AerialToggle!<CR>", { desc = "LSP Outline Toggle" })
	end,
}

return {
	"christoomey/vim-tmux-navigator",
	lazy = false,
	init = function()
		vim.g.tmux_navigator_no_mappings = 1
	end,
	config = function()
		vim.keymap.set("n", "<C-j>", ":TmuxNavigateLeft<cr>", { silent = true })
		vim.keymap.set("n", "<C-k>", ":TmuxNavigateDown<cr>", { silent = true })
		vim.keymap.set("n", "<C-l>", ":TmuxNavigateUp<cr>", { silent = true })
		vim.keymap.set("n", "<C-;>", ":TmuxNavigateRight<cr>", { silent = true })
	end,
}

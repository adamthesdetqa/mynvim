return {
	"RRethy/vim-illuminate",
	event = "BufReadPost",
	config = function()
		require("illuminate").configure({
			delay = 200, -- Adjust delay before highlighting (default: 100)
			filetypes_denylist = { "NvimTree", "neo-tree", "TelescopePrompt" }, -- Disable in these filetypes
			under_cursor = true, -- Highlight word under cursor
			min_count_to_highlight = 2, -- Only highlight if it appears at least twice
		})
	end,
}

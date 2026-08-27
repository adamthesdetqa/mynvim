return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		"tpope/vim-dadbod",
	},
	cmd = "DBUI",
	keys = {
		{ "<leader>db", "<cmd>DBUI<CR>", desc = "Toggle database UI" },
	},
	init = function()
		-- Homebrew's libpq is keg-only, so psql is never symlinked onto PATH.
		-- dadbod shells out to `psql`, so add it here if it isn't already found.
		if vim.fn.executable("psql") == 0 then
			for _, dir in ipairs({
				"/opt/homebrew/opt/libpq/bin",
				"/usr/local/opt/libpq/bin",
			}) do
				if vim.fn.isdirectory(dir) == 1 then
					vim.env.PATH = dir .. ":" .. vim.env.PATH
					break
				end
			end
		end
	end,
}

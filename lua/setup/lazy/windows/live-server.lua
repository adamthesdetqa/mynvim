return {
	"barrett-ruth/live-server.nvim",
	-- installs the `live-server` npm binary the plugin shells out to
	build = "npm install -g live-server",
	cmd = { "LiveServerStart", "LiveServerStop" },
	-- v0.2.0+ removed setup(); configure via vim.g.live_server before load
	init = function()
		vim.g.live_server = {}
	end,
	keys = {
		{ "<leader>Ls", "<cmd>LiveServerStart<CR>", desc = "Live server: start" },
		{ "<leader>LS", "<cmd>LiveServerStop<CR>", desc = "Live server: stop" },
	},
}

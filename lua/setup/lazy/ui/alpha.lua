return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		-- dashboard.section.header.val = {
		--   "                                                                                          ",
		--   "   ▄████████  ▄█  ▀████    ▐████▀  ▄█       ███    █▄     ▄█   ▄█▄    ▄████████ ▄██   ▄   ",
		--   "  ███    ███ ███    ███▌   ████▀  ███       ███    ███   ███ ▄███▀   ███    ███ ███   ██▄ ",
		--   "  ███    █▀  ███▌    ███  ▐███    ███       ███    ███   ███▐██▀     ███    █▀  ███▄▄▄███ ",
		--   "  ███        ███▌    ▀███▄███▀    ███       ███    ███  ▄█████▀     ▄███▄▄▄     ▀▀▀▀▀▀███ ",
		--   "▀███████████ ███▌    ████▀██▄     ███       ███    ███ ▀▀█████▄    ▀▀███▀▀▀     ▄██   ███ ",
		--   "         ███ ███    ▐███  ▀███    ███       ███    ███   ███▐██▄     ███    █▄  ███   ███ ",
		--   "   ▄█    ███ ███   ▄███     ███▄  ███▌    ▄ ███    ███   ███ ▀███▄   ███    ███ ███   ███ ",
		--   " ▄████████▀  █▀   ████       ███▄ █████▄▄██ ████████▀    ███   ▀█▀   ██████████  ▀█████▀  ",
		--   "                                  ▀                      ▀                                ",
		--   "                                                                                          ",
		-- }

		-- dashboard.section.header.val = {
		--   "                                                                                 ",
		--   "      # ###                                              /##             ###     ",
		--   "    /  /###  /                                         #/ ###             ###    ",
		--   "   /  /  ###/                            #            ##   ###             ##    ",
		--   "  /  ##   ##                            ##            ##                   ##    ",
		--   " /  ###                                 ##            ##                   ##    ",
		--   "##   ##        ###  /###     /###     ######## /##    ###### ##   ####     ##    ",
		--   "##   ##   ###   ###/ #### / / ###  / ######## / ###   #####   ##    ###  / ##    ",
		--   "##   ##  /###  / ##   ###/ /   ###/     ##   /   ###  ##      ##     ###/  ##    ",
		--   "##   ## /  ###/  ##       ##    ##      ##  ##    ### ##      ##      ##   ##    ",
		--   "##   ##/    ##   ##       ##    ##      ##  ########  ##      ##      ##   ##    ",
		--   " ##  ##     #    ##       ##    ##      ##  #######   ##      ##      ##   ##    ",
		--   "  ## #      /    ##       ##    ##      ##  ##        ##      ##      ##   ##    ",
		--   "   ###     /     ##       ##    /#      ##  ####    / ##      ##      /#   ##    ",
		--   "    ######/      ###       ####/ ##     ##   ######/  ##       ######/ ##  ### / ",
		--   "      ###         ###       ###   ##     ##   #####    ##       #####   ##  ##/  ",
		--   "                                                                                 ",
		--   "                                                                                 ",
		--   "                                                                                 ",
		--   "                                                                                 ",
		-- }

		dashboard.section.header.val = {
			"  __                                                                                                                                             ",
			"|/  |           /    /                   /                                                                /         /                            ",
			"|___| ___      (___ (___  ___       ___ (___  ___  ___  ___  ___            ___                 ___  ___ (___      (___  ___       ___  ___  ___ ",
			"|   )|___)     |    |   )|___)     |    |   )|   )|   )|   )|___)        )|   )|  )     |   )|   )|   )|         |    |   )     |___ |___)|___)",
			"|__/ |__       |__  |  / |__       |__  |  / |__/||  / |__/ |__        _/ |__/ |__/      |// |__/||  / |__       |__  |__/       __/ |__  |__  ",
			"                                                       __/              /                                                                        ",
		}

		-- Set menu
		-- dashboard.section.buttons.val = {
		--   dashboard.button("<space> er", "  > Toggle file explorer", "<Cmd>Neotree reveal<CR>"),
		--   dashboard.button("<space> ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
		--   dashboard.button("<space> fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
		--   dashboard.button("<space> wr", "󰁯  > Restore Session", "<cmd>SessionRestore<CR>"),
		--   dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
		-- }
		--
		-- -- send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- local colors = {
		--   blue = "#65D1FF",
		--   green = "#3EFFDC",
		--   violet = "#FF61EF",
		--   yellow = "#FFDA7B",
		--   red = "#FF4A4A",
		--   fg = "#c3ccdc",
		--   bg = "#112638",
		--   inactive_bg = "#2c3043",
		-- }
		--
		-- local my_lualine_theme = {
		--   normal = {
		--     a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
		--     b = { bg = colors.bg, fg = colors.fg },
		--     c = { bg = colors.bg, fg = colors.fg },
		--   },
		--   insert = {
		--     a = { bg = colors.green, fg = colors.bg, gui = "bold" },
		--     b = { bg = colors.bg, fg = colors.fg },
		--     c = { bg = colors.bg, fg = colors.fg },
		--   },
		--   visual = {
		--     a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
		--     b = { bg = colors.bg, fg = colors.fg },
		--     c = { bg = colors.bg, fg = colors.fg },
		--   },
		--   command = {
		--     a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
		--     b = { bg = colors.bg, fg = colors.fg },
		--     c = { bg = colors.bg, fg = colors.fg },
		--   },
		--   replace = {
		--     a = { bg = colors.red, fg = colors.bg, gui = "bold" },
		--     b = { bg = colors.bg, fg = colors.fg },
		--     c = { bg = colors.bg, fg = colors.fg },
		--   },
		--   inactive = {
		--     a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
		--     b = { bg = colors.inactive_bg, fg = colors.semilightgray },
		--     c = { bg = colors.inactive_bg, fg = colors.semilightgray },
		--   },
		-- }
		--

		local colors = {
			blue = "#7AA2F7", -- Softer blue
			green = "#9ECE6A", -- Muted green
			violet = "#BB9AF7", -- Tokyo Night's purple
			yellow = "#E0AF68", -- Softer yellow-orange
			red = "#F7768E", -- Muted red
			fg = "#FFFFFF", -- White foreground for contrast
			bg = "#141414", -- Darkest background
			bg_highlight = "#262626", -- Slightly lighter than bg
			inactive_bg = "#1A1A1A", -- Inactive background
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg_highlight, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg_highlight, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg_highlight, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg_highlight, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg_highlight, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			inactive = {
				a = { bg = colors.inactive_bg, fg = "#646464", gui = "bold" },
				b = { bg = colors.inactive_bg, fg = "#646464" },
				c = { bg = colors.inactive_bg, fg = "#646464" },
			},
		}

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = my_lualine_theme,
			},
			sections = {
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}

return {
	"folke/tokyonight.nvim",
	priority = 1000,
	config = function()
		-- local bg = "#011628"
		-- local bg_dark = "#011423"
		-- local bg_highlight = "#143652"
		-- local bg_search = "#0A64AC"
		-- local bg_visual = "#275378"
		-- local fg = "#CBE0F0"
		-- local fg_dark = "#B4D0E9"
		-- local fg_gutter = "#627E97"
		-- local border = "#547998"

		local bg = "#1A1A1A" -- Deep black
		local bg_dark = "#141414"
		local bg_highlight = "#262626" -- Softer grey
		local bg_search = "#B0752A" -- More opaque pastel orange
		local bg_visual = "#262626"
		local fg = "#FFFFFF" -- White
		local fg_dark = "#D0CAB8"
		local fg_gutter = "#646464"
		local border = "#1A1A1A"

		-- local bg = "#1F1F1F"
		-- local bg_dark = "#161616"
		-- local bg_highlight = "#392000"
		-- local bg_search = "#0A64AC"
		-- local bg_visual = "#4D2E04"
		-- local fg = "#F9E1CA"
		-- local fg_dark = "#FDF1C6"
		-- local fg_gutter = "#FD9D3C"
		-- local border = "#E57200"

		require("tokyonight").setup({
			style = "night",
			on_colors = function(colors)
				colors.bg = bg_dark
				colors.bg_dark = bg_dark
				colors.bg_float = bg_dark
				colors.bg_highlight = bg_highlight
				colors.bg_popup = bg_dark
				colors.bg_search = bg_search
				colors.bg_sidebar = bg
				colors.bg_statusline = bg_dark
				colors.bg_visual = bg_visual
				colors.border = border
				colors.fg = fg
				colors.fg_dark = fg_dark
				colors.fg_float = fg
				colors.fg_gutter = fg_gutter
				colors.fg_sidebar = fg_dark
			end,
		})
		-- load the colorscheme here
		vim.cmd([[colorscheme tokyonight]])
		-- Change highlight colors
		vim.cmd([[
			highlight IlluminatedWordText guibg=#412F16 guifg=NONE gui=italic
			highlight IlluminatedWordRead guibg=#412F16 guifg=NONE gui=italic
			highlight IlluminatedWordWrite guibg=#412F16 guifg=NONE gui=italic
		]])
	end,
}

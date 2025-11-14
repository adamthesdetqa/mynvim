return {
	"hrsh7th/nvim-cmp",
	version = false, -- last release is too old
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"onsails/lspkind.nvim",
	},
	opts = function()
		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

		local cmp = require("cmp")
		local defaults = require("cmp.config").default_config
		local auto_select = true

		return {
			auto_brackets = {}, -- configure filetypes for auto-brackets
			completion = {
				completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
			},
			preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = auto_select }),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
				["<C-CR>"] = function(fallback)
					cmp.abort()
					fallback()
				end,
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end, { "i", "s" }),
				-- ["K"] = function()
				-- 	if vim.lsp.buf.hover then
				-- 		vim.lsp.buf.hover()
				-- 	end
				-- end,
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "path" },
			}, {
				{ name = "buffer" },
			}),
			-- Enable completion for Angular templates
			filetype = {
				["typescript"] = { "nvim_lsp", "buffer", "path" },
				["html"] = { "nvim_lsp", "buffer", "path" },
				["typescript.html"] = { "nvim_lsp", "buffer", "path" },
			},
			formatting = {
				format = require("lspkind").cmp_format({
					mode = "Symbol_text",
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
			window = {
				completion = cmp.config.window.bordered({
					border = "rounded",
					winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
				}),
				documentation = cmp.config.window.bordered({
					border = "rounded",
					winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder",
				}),
			},
			-- sorting = defaults.sorting,
			vim.cmd([[
				highlight Pmenu guibg=#141414 guifg=#FFFFFF
				highlight PmenuSel guibg=#262626 guifg=#F9B044
				highlight PmenuBorder guifg=#B07F35
				highlight NormalFloat guibg=#141414
				highlight FloatBorder guifg=#1A1A1A guibg=#141414
				highlight CursorLine guibg=#262626
]]),
		}
	end,
}

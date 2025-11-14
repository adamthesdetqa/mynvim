return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "dprint", "prettier" },
				typescript = { "dprint" },
				-- typescript = { "dprint", "prettier" },
				typescriptreact = { "prettier" },
				javascriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier", "dprint" },
				scss = { "prettier", "dprint" },
				html = { "prettier", "dprint" },
				json = { "prettier", "dprint" },
				markdown = { "prettier", "dprint" },
				graphql = { "prettier" },
				lua = { "stylua" },
				go = { "gofmt", "goimports" },
			},
			format_on_save = true,
			formatters = {
				injected = { options = { ignore_errors = true } },
				-- prettier = {
				-- 	condition = function(ctx)
				-- 		return vim.fn.filereadable(ctx.dirname .. "/.prettierrc") == 1
				-- 	end,
				-- },
				dprint = {
					condition = function(ctx)
						return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
					end,
				},
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}

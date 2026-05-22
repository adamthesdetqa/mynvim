return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "dprint", "prettier", stop_after_first = true },
				typescript = { "dprint", "prettier", stop_after_first = true },
				typescriptreact = { "prettier" },
				javascriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier", "dprint", stop_after_first = true },
				scss = { "prettier", "dprint", stop_after_first = true },
				html = { "prettier", "dprint", stop_after_first = true },
				json = { "prettier", "dprint", stop_after_first = true },
				markdown = { "prettier", "dprint", stop_after_first = true },
				graphql = { "prettier" },
				lua = { "stylua" },
				go = { "gofmt", "goimports" },
				python = { "ruff_format", "ruff_organize_imports" },
			},
			format_on_save = function(bufnr)
				return {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				}
			end,
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

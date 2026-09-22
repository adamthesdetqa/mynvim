return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	event = "BufReadPost", -- keep ufo loading on file open, not just on the keys below
	keys = {
		{
			"<leader>zc",
			function()
				require("setup.comment-folds").close()
			end,
			desc = "Collapse all comments / JSDoc",
		},
		{ "<leader>zo", "zR", desc = "Expand all folds" },
	},
	config = function()
		local ufo = require("ufo")
		local comment_folds = require("setup.comment-folds")

		ufo.setup({
			-- Custom provider: normal folds from the LSP (indent as fallback), plus a
			-- fold for every comment block so comments can be collapsed on their own.
			provider_selector = function()
				return function(bufnr)
					local function with_comments(ranges)
						local seen, out = {}, {}
						for _, r in ipairs(ranges or {}) do
							seen[r.startLine] = true
							table.insert(out, r)
						end
						for _, r in ipairs(comment_folds.ranges(bufnr)) do
							if not seen[r.startLine] then
								table.insert(out, r)
							end
						end
						return out
					end

					return ufo.getFolds(bufnr, "lsp")
						:catch(function()
							return ufo.getFolds(bufnr, "indent")
						end)
						:thenCall(with_comments)
				end
			end,
		})
	end,
}

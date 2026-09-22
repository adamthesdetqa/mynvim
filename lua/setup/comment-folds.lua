-- Treesitter-derived fold ranges for comments only (line comments, block comments, JSDoc).
-- Fed into nvim-ufo as extra ranges so comments become foldable regions of their own.
local M = {}

local function blank_before(buf, row, col)
	if col == 0 then
		return true
	end
	local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
	return line:sub(1, col):match("^%s*$") ~= nil
end

--- @return table[] list of { startLine, endLine } (0-indexed, ufo's format)
function M.ranges(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local ok, parser = pcall(vim.treesitter.get_parser, buf)
	if not ok or not parser then
		return {}
	end

	-- collect every comment line first, so runs of consecutive `//` merge into one fold
	local is_comment = {}
	parser:parse(true)
	parser:for_each_tree(function(tree, ltree)
		local ok_query, query = pcall(vim.treesitter.query.parse, ltree:lang(), "(comment) @c")
		if not ok_query then
			return -- language has no `comment` node
		end
		for _, node in query:iter_captures(tree:root(), buf, 0, -1) do
			local srow, scol, erow, ecol = node:range()
			if ecol == 0 and erow > srow then
				erow = erow - 1
			end
			if not blank_before(buf, srow, scol) then
				srow = srow + 1 -- trailing comment: leave the code line it sits on alone
			end
			for l = srow, erow do
				is_comment[l] = true
			end
		end
	end)

	local ranges, start = {}, nil
	for l = 0, vim.api.nvim_buf_line_count(buf) do
		if is_comment[l] then
			start = start or l
		elseif start then
			if l - 1 > start then -- single-line comments aren't worth folding
				table.insert(ranges, { startLine = start, endLine = l - 1 })
			end
			start = nil
		end
	end
	return ranges
end

--- Close every comment fold, leaving code folds alone.
function M.close()
	local view = vim.fn.winsaveview()
	for _, r in ipairs(M.ranges()) do
		pcall(vim.cmd, ("%dfoldclose"):format(r.startLine + 1))
	end
	vim.fn.winrestview(view)
end

return M

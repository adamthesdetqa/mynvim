vim.g.mapleader = " " -- set leader key before Lazy
vim.g.maplocalleader = " " -- set leader key before Lazy

-- vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
-- vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
-- vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
-- vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" }) -- Smaller dot
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

require("setup.lazy-init")
require("setup.settings")
require("setup.keymaps")
-- Remap navigation keys in normal mode
-- First disable original hjkl navigation
vim.keymap.set("n", "h", "<Nop>", { noremap = true })
vim.keymap.set("n", "j", "<Nop>", { noremap = true })
vim.keymap.set("n", "k", "<Nop>", { noremap = true })
vim.keymap.set("n", "l", "<Nop>", { noremap = true })
--in visual mode
vim.keymap.set("v", "h", "<Nop>", { noremap = true })
vim.keymap.set("v", "j", "<Nop>", { noremap = true })
vim.keymap.set("v", "k", "<Nop>", { noremap = true })
vim.keymap.set("v", "l", "<Nop>", { noremap = true })
-- Then set up your custom navigation
vim.keymap.set("n", "j", "h", { noremap = true }) -- j moves left
vim.keymap.set("n", "k", "j", { noremap = true }) -- k moves down
vim.keymap.set("n", "l", "k", { noremap = true }) -- l moves up
vim.keymap.set("n", ";", "l", { noremap = true }) -- ; moves right
vim.keymap.set("v", "j", "h", { noremap = true }) -- j moves left
vim.keymap.set("v", "k", "j", { noremap = true }) -- k moves down
vim.keymap.set("v", "l", "k", { noremap = true }) -- l moves up
vim.keymap.set("v", ";", "l", { noremap = true }) -- ; moves right

-- Delete lines above and below mappings
vim.keymap.set("n","dk","dj", {noremap=true}) -- delete line and line below
vim.keymap.set("n","dl","dk", {noremap=true}) -- delete line and line above
-- Example mapping for basic window navigation (Normal mode)
vim.keymap.set('n', '<C-j>', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-k>', '<C-w>j', { desc = 'Go to down window' })
vim.keymap.set('n', '<C-l>', '<C-w>k', { desc = 'Go to up window' })
vim.keymap.set('n', '<C-;>', '<C-w>l', { desc = 'Go to right window' })
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Angular template filetype detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.component.html", "*.template.html" },
	callback = function()
		vim.bo.filetype = "htmlangular"
	end,
})

-- some hacky generated stuff
vim.keymap.set("n", "K", function()
	local winid = vim.fn.bufwinid("[Lsp Hover]") -- Check if hover is open
	if winid ~= -1 then
		vim.cmd("wincmd p") -- Jump into hover window if it's open
	else
		vim.lsp.buf.hover()
	end
end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-z>", "zt", { noremap = true, silent = true, desc = "Move current line to top" })



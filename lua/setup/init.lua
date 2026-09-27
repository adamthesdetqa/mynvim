vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.copilot_no_tab_map = true
-- hello
vim.keymap.set("i", "<C-y>", 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false,
	silent = true,
})

vim.keymap.set("i", "<C-;>", "copilot#AcceptWord()", {
	expr = true,
	replace_keycodes = false,
	silent = true,
})

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
})

-- Load core settings (works in both VS Code and terminal)
require("setup.settings")

-- Isolate VS Code-specific configuration from terminal Neovim
if vim.g.vscode then
	-- VS Code Neovim extension is running
	-- Load only keymaps and core settings (no UI plugins)
	require("setup.keymaps.vscode")
else
	-- Ordinary Neovim is running in terminal (WezTerm, iTerm, etc.)
	-- Load all plugins, UI, and terminal-specific keymaps
	require("setup.lazy-init")
	require("setup.keymaps")
end

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
vim.keymap.set("n", "j", "h", { noremap = true, desc = "Move left" })
vim.keymap.set("n", "k", "j", { noremap = true, desc = "Move down" })
vim.keymap.set("n", "l", "k", { noremap = true, desc = "Move up" })
vim.keymap.set("n", ";", "l", { noremap = true, desc = "Move right" })
vim.keymap.set("v", "j", "h", { noremap = true, desc = "Move left" })
vim.keymap.set("v", "k", "j", { noremap = true, desc = "Move down" })
vim.keymap.set("v", "l", "k", { noremap = true, desc = "Move up" })
vim.keymap.set("v", ";", "l", { noremap = true, desc = "Move right" })

-- Delete lines above and below mappings
vim.keymap.set("n", "dk", "dj", { noremap = true, desc = "Delete line and line below" })
vim.keymap.set("n", "dl", "dk", { noremap = true, desc = "Delete line and line above" })
-- Example mapping for basic window navigation (Normal mode)
vim.keymap.set("n", "<C-j>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-k>", "<C-w>j", { desc = "Go to down window" })
vim.keymap.set("n", "<C-l>", "<C-w>k", { desc = "Go to up window" })
vim.keymap.set("n", "<C-;>", "<C-w>l", { desc = "Go to right window" })
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

vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover()
end, { noremap = true, silent = true, desc = "LSP Hover / Focus Hover Window" })
vim.keymap.set("n", "<C-z>", "zt", { noremap = true, silent = true, desc = "Move current line to top" })

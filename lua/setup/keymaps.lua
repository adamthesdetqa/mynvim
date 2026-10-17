-- set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------
--
keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- use jk to exit insert/visual mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("v", "jk", "<ESC>", { desc = "Exit visual mode with jk" })
keymap.set("t", "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode with jk" })

-- terminal
keymap.set({ "n", "t" }, "<C-/>", function()
	Snacks.terminal.toggle()
end, { desc = "Toggle Terminal" })
keymap.set({ "n", "t" }, "<leader>ft", function()
	Snacks.terminal.toggle()
end, { desc = "Toggle Terminal" })

-- noice message history
keymap.set("n", "<leader>nm", "<cmd>Noice history<CR>", { desc = "Noice Message History" })

-- normal mode vscode like keymaps
keymap.set("n", "<M-Up>", ":m-2<CR>", { desc = "move line above" })
keymap.set("n", "<M-Down>", ":m+1<CR>", { desc = "move line down" })

-- Remap for dealing with word wrap
-- keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- run current file across supported languages (Python, JS/TS, Go, Lua, Shell)
local runner_term = nil
keymap.set("n", "<leader>rr", function()
	local ft = vim.bo.filetype
	if vim.bo.modified and vim.bo.buftype == "" then
		pcall(vim.cmd, "silent write")
	end
	local file = vim.fn.shellescape(vim.fn.expand("%:p"))
	local cmd

	if ft == "python" then
		local python = "python3"
		local ok_vs, vs = pcall(require, "venv-selector")
		if ok_vs and vs.python() and vs.python() ~= "" then
			python = vs.python()
		elseif vim.env.VIRTUAL_ENV and vim.uv.fs_stat(vim.env.VIRTUAL_ENV .. "/bin/python") then
			python = vim.env.VIRTUAL_ENV .. "/bin/python"
		elseif vim.uv.fs_stat(vim.fn.getcwd() .. "/.venv/bin/python") then
			python = vim.fn.getcwd() .. "/.venv/bin/python"
		end
		cmd = vim.fn.shellescape(python) .. " " .. file
	elseif ft == "javascript" then
		cmd = "node " .. file
	elseif ft == "typescript" then
		cmd = "npx tsx " .. file
	elseif ft == "go" then
		cmd = "go run " .. file
	elseif ft == "lua" then
		cmd = "nvim -l " .. file
	elseif ft == "sh" or ft == "bash" or ft == "zsh" then
		cmd = ft .. " " .. file
	else
		vim.notify("No runner configured for filetype: " .. (ft ~= "" and ft or "none"), vim.log.levels.WARN)
		return
	end

	if runner_term and runner_term.close then
		pcall(function()
			runner_term:close()
		end)
	end

	runner_term = Snacks.terminal.open(cmd, {
		auto_close = false,
		start_insert = false,
		auto_insert = false,
		win = {
			position = "bottom",
			height = 0.3,
		},
	})
end, { desc = "Run Current File" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- open flutter tools in window
-- keymap.set("n", "<leader>fl", require("telescope").extensions.flutter.commands, { desc = "Open Flutter Commands" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- LSP / Mason management
keymap.set("n", "<leader>cl", "<cmd>LspInfo<CR>", { desc = "LSP Info" })
keymap.set("n", "<leader>cm", "<cmd>Mason<CR>", { desc = "Open Mason" })

-- reload neovim config
keymap.set("n", "<leader>rc", function()
	for name, _ in pairs(package.loaded) do
		if name:match("^setup") then
			package.loaded[name] = nil
		end
	end
	require("setup.settings")
	require("setup.keymaps")
	vim.notify("Configuration reloaded!")
end, { desc = "Reload Neovim Config" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf, silent = true }

		-- set keybinds (both g* and <leader>g* supported)
		opts.desc = "Show LSP references"
		keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
		keymap.set("n", "<leader>gR", "<cmd>Telescope lsp_references<CR>", opts)
		keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>", opts)

		opts.desc = "Go to declaration"
		keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)

		opts.desc = "Show LSP definitions"
		keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
		keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", opts)

		opts.desc = "Show LSP implementations"
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.supports_method("textDocument/implementation") then
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
			keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts)
		end

		opts.desc = "Show LSP type definitions"
		keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
		keymap.set("n", "<leader>gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

		opts.desc = "See available code actions"
		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

		opts.desc = "Organize Imports"
		keymap.set("n", "<leader>co", function()
			if vim.bo[ev.buf].filetype == "python" then
				require("conform").format({ bufnr = ev.buf, formatters = { "ruff_organize_imports" } })
			else
				vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" }, diagnostics = {} }, apply = true })
			end
		end, opts)

		opts.desc = "Smart rename"
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

		opts.desc = "Show buffer diagnostics"
		keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

		opts.desc = "Show line diagnostics"
		keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

		opts.desc = "Go to previous diagnostic"
		keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts) -- jump to previous diagnostic in buffer

		opts.desc = "Go to next diagnostic"
		keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts) -- jump to next diagnostic in buffer

		opts.desc = "Restart LSP"
		keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
	end,
})

-- local client = vim.lsp.start_client({
-- 	name = "educationalsp",
-- 	cmd = { "/Users/sixlukey/Development/golang-dev/educationalsp/main" },
-- })
--
-- if not client then
-- 	vim.notify("No client found!")
-- 	return
-- end
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "markdown",
-- 	callback = function()
-- 		vim.lsp.buf_attach_client(0, client)
-- 	end,
-- })

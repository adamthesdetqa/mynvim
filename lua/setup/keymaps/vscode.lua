-- VS Code Neovim keymaps
-- Only includes mappings that work without plugins
-- Terminal-specific keymaps are in setup/keymaps.lua

local keymap = vim.keymap

---------------------
-- General Keymaps ---
---------------------

keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- use jk to exit insert/visual mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("v", "jk", "<ESC>", { desc = "Exit visual mode with jk" })
keymap.set("t", "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode with jk" })

-- normal mode vscode-like keymaps
keymap.set("n", "<M-Up>", ":m-2<CR>", { desc = "Move line above" })
keymap.set("n", "<M-Down>", ":m+1<CR>", { desc = "Move line down" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- reload neovim config
keymap.set("n", "<leader>rc", function()
	for name, _ in pairs(package.loaded) do
		if name:match("^setup") then
			package.loaded[name] = nil
		end
	end
	require("setup.settings")
	require("setup.keymaps.vscode")
	vim.notify("VS Code Neovim configuration reloaded!")
end, { desc = "Reload Neovim Config" })

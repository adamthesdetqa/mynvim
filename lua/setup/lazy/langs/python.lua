return {
	{
		"sheng-tse/jupynvim",
		lazy = false, -- must load so BufReadCmd("*.ipynb") is active before any .ipynb is opened
		build = function(plugin)
			local install = loadfile(plugin.dir .. "/lua/jupynvim/install.lua")()
			install.run(plugin)
		end,
		config = function()
			require("jupynvim").setup({
				log_level = "info",
				image_renderer = "placeholder", -- "placeholder" (Ghostty/Kitty), "kitty", or "chafa"
				auto_venv = true,
				-- Do not hijack local Neo-tree (<leader>e), Snacks terminal (<C-/>), or Telescope (<leader>ff)
				explorer_keys = {},
				explorer_cwd_keys = {},
				terminal_keys = {},
				terminal_right_keys = {},
				pick_keys = { files = {}, grep = {} },
				-- Map notebook actions under <leader>j (+Jupyter) so they match your config and
				-- don't collide with <leader>nm (Noice) or <leader>nh (Clear search highlights)
				keymaps = {
					run_advance = "<S-CR>",
					run_stay = "<C-CR>",
					run_advance_alt = "<leader>jc",
					run_all = "<leader>jA",
					run_above = "<leader>ja",
					run_below = "<leader>jb",
					add_above = "<leader>jO",
					add_below = "<leader>jo",
					delete_cell = "<leader>jd",
					move_up = "<leader>jl",
					move_down = "<leader>jk",
					to_markdown = "<leader>jm",
					to_code = "<leader>jy",
					pick_kernel = "<leader>jK",
					start_kernel = "<leader>ji",
					stop_kernel = "<leader>jq",
					interrupt_kernel = "<leader>jI",
					restart_kernel = "<leader>jr",
					expand_output = "<leader>je",
					hide_output = "<leader>jh",
					limit_output = "<leader>jL",
					clear_output = "<leader>jx",
					clear_all = "<leader>jX",
					enter_output_dn = "<leader>jf",
					enter_output_up = "<leader>jF",
					save_image = "<leader>js",
					delete_image = "<leader>jD",
					refresh = "<leader>jR",
				},
			})

			-- Adapt jupynvim's notebook cellmode (which binds j=down, k=up buffer-locally)
			-- to match your custom navigation: j=left, k=down, l=up, ;=right
			local ok_cm, cellmode = pcall(require, "jupynvim.notebook.cellmode")
			if ok_cm and type(cellmode.attach) == "function" then
				local orig_attach = cellmode.attach
				cellmode.attach = function(buf, api)
					orig_attach(buf, api)
					local down_cb, up_cb
					for _, m in ipairs(vim.api.nvim_buf_get_keymap(buf, "n")) do
						if m.lhs == "<Down>" then
							down_cb = m.callback
						elseif m.lhs == "<Up>" then
							up_cb = m.callback
						end
					end
					-- Remove buffer-local j so global j -> h (left) works in edit mode
					pcall(vim.keymap.del, "n", "j", { buffer = buf })
					if down_cb then
						vim.keymap.set("n", "k", down_cb, {
							buffer = buf,
							silent = true,
							nowait = true,
							desc = "jupynvim: next cell (command) / down in cell (edit)",
						})
					end
					if up_cb then
						vim.keymap.set("n", "l", up_cb, {
							buffer = buf,
							silent = true,
							nowait = true,
							desc = "jupynvim: prev cell (command) / up in cell (edit)",
						})
					end
				end
			end
		end,
	},
}

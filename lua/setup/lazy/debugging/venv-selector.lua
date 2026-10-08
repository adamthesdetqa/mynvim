local function molten_auto_init(python_path)
	if vim.b.molten_initialized then
		return
	end

	-- molten-nvim and venv-selector.nvim both lazy-load on the same FileType event, so there's
	-- no guarantee molten has already finished loading by the time this callback runs. Force it
	-- deterministically via lazy.nvim's own load API instead of guessing with a fixed delay.
	require("lazy").load({ plugins = { "molten-nvim" } })

	local ok_molten = pcall(vim.fn.MoltenAvailableKernels)
	if not ok_molten then
		return -- molten-nvim failed to load or its remote-plugin host isn't available
	end

	-- Find a registered Jupyter kernel whose interpreter matches the active venv, by reading
	-- ~/Library/Jupyter/kernels/*/kernel.json (the same files `python -m ipykernel install`
	-- writes). This lets a one-time `python -m ipykernel install --user --name=<x>` inside a
	-- venv, plus a one-time <leader>vs pick, be enough for every future session to auto-attach.
	local kernel_name = nil
	for _, dir in ipairs(vim.fn.glob("~/Library/Jupyter/kernels/*", false, true)) do
		local ok_read, lines = pcall(vim.fn.readfile, dir .. "/kernel.json")
		if ok_read then
			local ok_json, spec = pcall(vim.json.decode, table.concat(lines, "\n"))
			if ok_json and spec.argv and spec.argv[1] == python_path then
				kernel_name = vim.fn.fnamemodify(dir, ":t")
				break
			end
		end
	end

	if not kernel_name then
		vim.notify(
			"No Jupyter kernel registered for "
				.. python_path
				.. " -- run `python -m ipykernel install --user --name=<name>` inside that venv once, then :MoltenInit manually.",
			vim.log.levels.WARN,
			{ title = "Molten" }
		)
		return
	end

	vim.b.molten_initialized = true
	vim.cmd("MoltenInit " .. kernel_name)
	vim.notify("Molten kernel '" .. kernel_name .. "' auto-initialized", vim.log.levels.INFO, { title = "Molten" })
end

return {
	"linux-cultist/venv-selector.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	ft = { "python", "quarto" }, -- jupytext now presents python .ipynb notebooks as filetype=quarto
	opts = {
		options = {
			-- Defaults to true, which reassigns vim.notify to the raw nvim-notify plugin
			-- table, stomping on Noice's own management of vim.notify (Noice depends on
			-- nvim-notify too, so it's always present) and triggering Noice's
			-- "vim.notify has been overwritten" warning. Noice already routes notifications
			-- through nvim-notify itself, so there's nothing to gain from this override.
			override_notify = false,
			-- Fires after every venv activation (manual pick, or cache-restored on buffer-enter --
			-- the cache-restore path is what makes this "automatic" on every future project open,
			-- once you've picked a venv for that project a single time with <leader>vs).
			-- pyright needs no handling here: venv-selector restarts the *live* LSP client via
			-- vim.lsp.start() with a deep-merged config, so the existing
			-- vim.lsp.config('pyright', {...}) block in lazy-init.lua is untouched and its
			-- settings.python.analysis.* survive the merge. This callback exists only to
			-- reconcile the two OTHER hardcoded python paths in this config -- dap.lua's
			-- dap-python setup() and neotest.lua's neotest-python adapter -- and to auto-run
			-- :MoltenInit against whichever registered Jupyter kernel matches this venv, so you
			-- don't have to run it by hand every time you reopen a notebook.
			on_venv_activate_callback = function()
				local venv_python = require("venv-selector").python()
				if not venv_python or venv_python == "" then
					return
				end

				local ok_dap, dap_python = pcall(require, "dap-python")
				if ok_dap then
					dap_python.setup(venv_python)
				end

				local ok_neotest, neotest = pcall(require, "neotest")
				if ok_neotest then
					-- Keep this adapter list in sync with lazy/debugging/neotest.lua if it changes.
					neotest.setup({
						adapters = {
							require("neotest-vitest"),
							require("neotest-jest")({
								jestCommand = "pnpm test",
								env = { CI = true },
								cwd = function()
									return vim.fn.getcwd()
								end,
							}),
							require("neotest-python")({ runner = "pytest", python = venv_python }),
						},
					})
				end

				molten_auto_init(venv_python)

				vim.notify("Synced dap-python/neotest to " .. venv_python, vim.log.levels.INFO, { title = "VenvSelect" })
			end,
		},
	},
	keys = {
		{ "<leader>vs", "<cmd>VenvSelect<CR>", desc = "Select Python venv" },
	},
}

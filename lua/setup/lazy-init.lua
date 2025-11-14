local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	change_detection = { notify = false },
	{ import = "setup.lazy" },
	{ import = "setup.lazy.debugging" },
	-- { import = "setup.lazy.langs" },
	{ import = "setup.lazy.mappings" },
	{ import = "setup.lazy.ui" },
	{ import = "setup.lazy.windows" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ "neovim/nvim-lspconfig" },
	-- { "hrsh7th/cmp-nvim-lsp" },
	-- { "hrsh7th/nvim-cmp" },
	{ "nvim-neotest/nvim-nio" },
	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",

	-- Snippets
	-- 'SirVer/ultisnips',
	"honza/vim-snippets",
	"morhetz/gruvbox",

	"saghen/blink.cmp",

	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	{ "L3MON4D3/LuaSnip" },
	{ "akinsho/git-conflict.nvim", version = "*", config = true },
}, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"vtsls",
		"html",
		"cssls",
		"angularls",
		"bashls",
		"tailwindcss",
		"svelte",
		"lua_ls",
		"emmet_ls",
	},
	handlers = {
		-- Custom handler for Angular LSP to enable template completion
		angularls = function()
			require("lspconfig").angularls.setup({
				capabilities = require("blink.cmp").get_lsp_capabilities(),
				filetypes = { "typescript", "html", "typescript.html", "htmlangular" },
				root_dir = require("lspconfig.util").root_pattern("angular.json", "package.json", "tsconfig.json"),
				on_attach = function(client, bufnr)
					-- Enable all completion capabilities for Angular templates
					client.server_capabilities.completionProvider = true
					client.server_capabilities.hoverProvider = true
					client.server_capabilities.definitionProvider = true
					client.server_capabilities.referencesProvider = true
					print("Angular LSP attached to buffer " .. bufnr)
				end,
				settings = {
					angular = {
						enable = true,
						enableTemplateTypeChecking = true,
						enableStrictModePipes = true,
						enableStrictModeInjectionParameters = true,
						enableIvy = true,
						experimental = {
							enableTemplateTypeChecker = true,
						},
					},
				},
			})
		end,
		-- Default handler for other LSPs
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
	},
})
require("mason-tool-installer").setup({
	ensure_installed = {
		"dprint",
		"prettier", -- prettier formatter
		"stylua", -- lua formatter
		"eslint_d", -- js linter
	},
})

local capabilities = require("blink.cmp").get_lsp_capabilities()

require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				},
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			},
		})
	end,
	settings = {
		Lua = {},
	},
})

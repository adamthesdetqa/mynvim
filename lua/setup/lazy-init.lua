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
	{ "hrsh7th/cmp-nvim-lsp" }, -- must load at startup so require("cmp_nvim_lsp") works in LSP handlers
	-- { "hrsh7th/nvim-cmp" },
	{ "nvim-neotest/nvim-nio" },
	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",

	-- Snippets
	-- 'SirVer/ultisnips',
	"honza/vim-snippets",
	"morhetz/gruvbox",

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
		"pyright",
	},
	handlers = {
		-- Custom handler for Angular LSP to enable template completion
		angularls = function()
			vim.lsp.config('angularls', {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				filetypes = { "typescript", "html", "typescript.html", "htmlangular" },
				root_dir = function(bufnr, on_dir)
					on_dir(vim.fs.root(bufnr, { "angular.json", "package.json", "tsconfig.json" }))
				end,
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
			vim.lsp.enable('angularls')
		end,
		-- Default handler for other LSPs
		function(server_name)
			vim.lsp.enable(server_name)
		end,
	},
})
require("mason-tool-installer").setup({
	ensure_installed = {
		"dprint",
		"prettier", -- prettier formatter
		"stylua", -- lua formatter
		"eslint_d", -- js linter
		"ruff", -- python linter/formatter
	},
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config('pyright', {
	capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic",
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
})
vim.lsp.enable('pyright')

vim.lsp.config('lua_ls', {
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
vim.lsp.enable('lua_ls')

-- Auto-import missing symbols on save for TS/JS files (via vtsls)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("AutoAddMissingImports", { clear = true }),
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.mts", "*.cts" },
  callback = function(args)
    local bufnr = args.buf
    -- Find a client that can provide code actions (e.g. vtsls)
    local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })
    if #clients == 0 then
      return
    end
    local encoding = clients[1].offset_encoding or "utf-16"

    -- Synchronously request and apply the "add missing imports" source action
    local params = vim.lsp.util.make_range_params(0, encoding)
    params.context = {
      only = { "source.addMissingImports.ts" },
      diagnostics = {},
    }
    local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
    for _, res in pairs(results or {}) do
      for _, action in pairs(res.result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, encoding)
        end
        if type(action.command) == "table" then
          clients[1]:exec_cmd(action.command, { bufnr = bufnr })
        end
      end
    end
  end,
})

-- Autosave on CursorHold event
vim.opt.updatetime = 5000 -- Time in milliseconds (e.g., 5000ms = 5 seconds)
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("AutoSave", { clear = true }),
  callback = function()
    -- The update command writes the current buffer if it has been modified
    vim.cmd("silent! update")
  end,
})


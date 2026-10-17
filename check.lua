#!/usr/bin/env -S nvim -l
-- Config verification & smoke-test suite for ~/.config/nvim
-- Run from terminal:
--   nvim -l check.lua

local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
package.path = config_dir .. "/lua/?.lua;" .. config_dir .. "/lua/?/init.lua;" .. package.path

local passed = 0
local warnings = 0
local failed = 0

local function pass(msg)
	passed = passed + 1
	print(string.format("  \27[32m✓\27[0m %s", msg))
end

local function warn(msg)
	warnings = warnings + 1
	print(string.format("  \27[33m⚠\27[0m %s", msg))
end

local function fail(msg)
	failed = failed + 1
	print(string.format("  \27[31m✗\27[0m %s", msg))
end

local function section(title)
	print(string.format("\n\27[1;34m=== %s ===\27[0m", title))
end

-- 1. Lua Syntax & Lazy Spec Structure
section("1. Lua Syntax & Plugin Spec Validation")
local lua_files = vim.fn.globpath(config_dir .. "/lua", "**/*.lua", false, true)
table.insert(lua_files, 1, config_dir .. "/init.lua")

local syntax_errors = 0
local spec_count = 0
for _, file in ipairs(lua_files) do
	local rel = file:sub(#config_dir + 2)
	local chunk, err = loadfile(file)
	if not chunk then
		fail(string.format("Syntax error in %s: %s", rel, err))
		syntax_errors = syntax_errors + 1
	elseif rel:match("^lua/setup/lazy/") then
		local ok, res = pcall(chunk)
		if not ok then
			fail(string.format("Error evaluating plugin spec %s: %s", rel, res))
			syntax_errors = syntax_errors + 1
		elseif type(res) ~= "table" then
			fail(string.format("Plugin spec %s returned %s instead of table", rel, type(res)))
			syntax_errors = syntax_errors + 1
		else
			spec_count = spec_count + 1
		end
	end
end

if syntax_errors == 0 then
	pass(string.format("All %d Lua files compiled cleanly (%d lazy plugin spec files verified)", #lua_files, spec_count))
end

-- 2. Leader Keymap Duplicate & Prefix Overlap Check
section("2. Leader Keymap Conflict & Prefix Overlap Check")
local mappings = {}
for _, file in ipairs(lua_files) do
	local rel = file:sub(#config_dir + 2)
	if not rel:match("vscode%.lua$") and not rel:match("which%-key%.lua$") then
		local lines = vim.fn.readfile(file)
		for lnum, line in ipairs(lines) do
			local stripped = vim.trim(line)
			if not stripped:match("^%-%-") and not stripped:match("rtxt%s*=") then
				for key in stripped:gmatch('"(<leader>[^"]+)"') do
					-- Determine modes if specified on the same line
					local mode = "n"
					if stripped:match('map%("v"') or stripped:match('mode%s*=%s*"v"') then
						mode = "v"
					elseif stripped:match('mode%s*=%s*{[^}]*"v"') or stripped:match('keymap%.set%({[^}]*"v"') then
						mode = "nv"
					end
					table.insert(mappings, {
						key = key,
						mode = mode,
						loc = string.format("%s:%d", rel, lnum),
						line = stripped,
					})
				end
			end
		end
	end
end

local by_key_mode = {}
local dup_count = 0
for _, m in ipairs(mappings) do
	local modes = m.mode == "nv" and { "n", "v" } or { m.mode }
	for _, md in ipairs(modes) do
		local id = md .. ":" .. m.key
		if by_key_mode[id] then
			fail(string.format("Duplicate <%s> mapping %s in %s and %s", md, m.key, by_key_mode[id], m.loc))
			dup_count = dup_count + 1
		else
			by_key_mode[id] = m.loc
		end
	end
end

local unique_keys = {}
local key_locs = {}
for _, m in ipairs(mappings) do
	if not key_locs[m.key] then
		key_locs[m.key] = m.loc
		table.insert(unique_keys, m.key)
	end
end
table.sort(unique_keys)

local overlap_count = 0
for i = 1, #unique_keys do
	for j = i + 1, #unique_keys do
		local k1, k2 = unique_keys[i], unique_keys[j]
		if k2:sub(1, #k1) == k1 and k2 ~= k1 then
			fail(string.format("Prefix overlap: %s (%s) delays/conflicts with %s (%s)", k1, key_locs[k1], k2, key_locs[k2]))
			overlap_count = overlap_count + 1
		end
	end
end

if dup_count == 0 and overlap_count == 0 then
	pass(string.format("Verified %d unique <leader> mappings with 0 duplicates and 0 prefix overlaps", #unique_keys))
end

-- 3. Core Settings & Python Host Check
section("3. Core Settings & Python Provider")
local ok_settings, err_settings = pcall(require, "setup.settings")
if ok_settings then
	pass("lua/setup/settings.lua loaded cleanly")
else
	fail("Failed to load lua/setup/settings.lua: " .. tostring(err_settings))
end

local py_host = vim.g.python3_host_prog
if py_host and vim.fn.executable(py_host) == 1 then
	pass("Python 3 host provider executable: " .. py_host)
	local py_bin_dir = vim.fn.fnamemodify(py_host, ":h")
	local user_py_bin = vim.fn.expand("~/Library/Python/" .. py_host:match("Versions/([%d%.]+)/") .. "/bin")
	for _, d in ipairs({ py_bin_dir, user_py_bin }) do
		if vim.fn.isdirectory(d) == 1 and not vim.env.PATH:find(d, 1, true) then
			vim.env.PATH = d .. ":" .. vim.env.PATH
		end
	end
else
	fail("Python 3 host provider missing or not executable: " .. tostring(py_host))
end

-- 4. Mason Packages & CLI Binaries (Python & JS/TS)
section("4. Mason LSPs, Formatters & System Tools")
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
local mason_tools = {
	{ bin = "pyright-langserver", desc = "Pyright LSP (Python)" },
	{ bin = "ruff", desc = "Ruff Linter/Formatter (Python)" },
	{ bin = "debugpy", desc = "Debugpy Adapter (Python DAP)" },
	{ bin = "vtsls", desc = "vtsls LSP (TypeScript/JavaScript)" },
	{ bin = "ngserver", desc = "Angular LSP" },
	{ bin = "eslint_d", desc = "ESLint Daemon (JS/TS)" },
	{ bin = "prettier", desc = "Prettier Formatter (JS/TS/HTML/CSS)" },
	{ bin = "dprint", desc = "dprint Formatter (JS/TS)" },
	{ bin = "stylua", desc = "StyLua Formatter (Lua)" },
	{ bin = "lua-language-server", desc = "lua_ls (Lua)" },
}

for _, tool in ipairs(mason_tools) do
	local path = mason_bin .. "/" .. tool.bin
	if vim.uv.fs_stat(path) then
		pass(string.format("Mason tool %-20s (%s)", tool.bin, tool.desc))
	else
		fail(string.format("Missing Mason tool %-14s (%s) — run :Mason inside Neovim", tool.bin, tool.desc))
	end
end

local sys_tools = {
	{ bin = "python3", required = true, desc = "Python 3 interpreter" },
	{ bin = "node", required = true, desc = "Node.js runtime (LSPs & JS)" },
	{ bin = "rg", required = true, desc = "ripgrep (Telescope live_grep)" },
	{ bin = "fd", required = true, desc = "fd (venv-selector discovery)" },
	{ bin = "uv", required = false, desc = "uv Python package/venv manager" },
}

for _, tool in ipairs(sys_tools) do
	if vim.fn.executable(tool.bin) == 1 then
		pass(string.format("System binary %-17s (%s)", tool.bin, tool.desc))
	elseif tool.required then
		fail(string.format("Missing required binary %-10s (%s)", tool.bin, tool.desc))
	else
		warn(string.format("Optional binary not installed: %-8s (%s)", tool.bin, tool.desc))
	end
end

-- Check jupynvim-core Rust backend binary
local jupynvim_bin = vim.fn.stdpath("data") .. "/lazy/jupynvim/core/target/release/jupynvim-core"
if vim.uv.fs_stat(jupynvim_bin) then
	pass("jupynvim-core Rust backend binary installed")
elseif loadfile(vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy/init.lua") then
	fail("jupynvim-core binary missing — run :JupynvimInstall inside Neovim")
end

-- 5. Full Runtime Boot Check (when ~/.local/share/nvim is accessible)
section("5. Full Runtime & Plugin Load Check")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_init_chunk = loadfile(lazypath .. "/lua/lazy/init.lua")
if lazy_init_chunk then
	local ok_init, init_err = pcall(dofile, config_dir .. "/init.lua")
	if not ok_init then
		fail("Error loading init.lua: " .. tostring(init_err))
	else
		pass("init.lua and lazy.nvim booted with zero Lua exceptions")
		local ok_conform, conform = pcall(require, "conform")
		if ok_conform then
			if conform.formatters_by_ft.python and conform.formatters_by_ft.typescript then
				pass("conform.nvim formatters configured for Python (" .. table.concat(conform.formatters_by_ft.python, ", ") .. ") & JS/TS")
			else
				fail("conform.nvim missing Python or TypeScript formatter config")
			end
		end
	end
else
	warn("Skipped full lazy.nvim runtime boot (run `nvim -l check.lua` directly in your terminal to include runtime plugin boot)")
end

print(string.format("\n\27[1mSummary:\27[0m \27[32m%d passed\27[0m, \27[33m%d warnings\27[0m, \27[31m%d failed\27[0m\n", passed, warnings, failed))
if failed > 0 then
	os.exit(1)
end

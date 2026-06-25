-- Tests for the neo-tree context menu in lua/setup/lazy/ui/menu.lua
-- Run with: :PlenaryBustedFile tests/menu_neotree_spec.lua
-- Or from shell: nvim --headless -c "PlenaryBustedFile tests/menu_neotree_spec.lua"

local assert = require "luassert"

-- ---------------------------------------------------------------------------
-- Helpers / stubs
-- ---------------------------------------------------------------------------

local function make_node(opts)
	return {
		type = opts.type or "file",
		path = opts.path or "/tmp/test/file.lua",
	}
end

local function make_state(name, node)
	local tree = { get_node = function() return node end }
	return {
		name = name or "filesystem",
		config = {},
		tree = tree,
	}
end

-- Stub out neo-tree manager so we can control what get_state_for_window returns.
local function stub_manager(state)
	package.loaded["neo-tree.sources.manager"] = {
		get_state_for_window = function() return state end,
	}
end

-- Stub neo-tree source commands.
local function stub_commands(source, cmds)
	package.loaded["neo-tree.sources." .. source .. ".commands"] = cmds or {}
	package.loaded["neo-tree.sources.common.commands"] = cmds or {}
end

local function reset_stubs()
	package.loaded["neo-tree.sources.manager"] = nil
	package.loaded["neo-tree.sources.filesystem.commands"] = nil
	package.loaded["neo-tree.sources.common.commands"] = nil
	package.loaded["menu"] = nil
end

-- ---------------------------------------------------------------------------
-- Extraction helper: load menu.lua and call get_neotree_menu()
-- We expose it by temporarily monkey-patching the module loader.
-- ---------------------------------------------------------------------------

-- Pull out get_neotree_menu from the actual file without running the whole
-- lazy plugin spec (which requires nvim plugins to be loaded).
local function load_neotree_menu_fn()
	-- We can't require the full plugin spec file (it returns a lazy spec table),
	-- so we extract and dofile just the get_neotree_menu function.
	local src_path = vim.fn.stdpath("config") .. "/lua/setup/lazy/ui/menu.lua"
	local src = assert(io.open(src_path, "r")):read("*a")

	-- Isolate the get_neotree_menu function body and compile it.
	local fn_src = src:match("(local function get_neotree_menu%b().-\nend)")
	assert(fn_src, "Could not extract get_neotree_menu from menu.lua")

	-- Wrap in a module that returns the function.
	local wrapped = fn_src .. "\nreturn get_neotree_menu"
	local chunk, err = load(wrapped, "get_neotree_menu", "t")
	assert(chunk, "Failed to compile get_neotree_menu: " .. tostring(err))
	return chunk()
end

-- ---------------------------------------------------------------------------
-- Tests
-- ---------------------------------------------------------------------------

describe("neo-tree context menu", function()
	local get_neotree_menu

	before_each(function()
		reset_stubs()
		get_neotree_menu = load_neotree_menu_fn()
	end)

	after_each(function()
		reset_stubs()
	end)

	-- -------------------------------------------------------------------------
	describe("get_neotree_menu()", function()
		it("returns 'default' when neo-tree state is nil", function()
			stub_manager(nil)
			stub_commands("filesystem")
			local result = get_neotree_menu()
			assert.equals("default", result)
		end)

		it("returns a table of menu items when state is valid", function()
			local node = make_node({})
			local state = make_state("filesystem", node)
			stub_manager(state)
			stub_commands("filesystem")

			local items = get_neotree_menu()
			assert.is_table(items)
			assert.is_true(#items > 0)
		end)

		it("every non-separator item has a name field", function()
			local node = make_node({})
			stub_manager(make_state("filesystem", node))
			stub_commands("filesystem")

			for _, item in ipairs(get_neotree_menu()) do
				assert.is_string(item.name, "item missing name field")
			end
		end)

		it("every non-separator item has a cmd field", function()
			local node = make_node({})
			stub_manager(make_state("filesystem", node))
			stub_commands("filesystem")

			for _, item in ipairs(get_neotree_menu()) do
				if item.name ~= "separator" then
					assert.is_not_nil(item.cmd, "item '" .. item.name .. "' missing cmd")
				end
			end
		end)

		it("cmd fields are callable", function()
			local node = make_node({})
			stub_manager(make_state("filesystem", node))
			stub_commands("filesystem")

			for _, item in ipairs(get_neotree_menu()) do
				if item.name ~= "separator" then
					assert.equals("function", type(item.cmd),
						"cmd for '" .. item.name .. "' is not a function")
				end
			end
		end)
	end)

	-- -------------------------------------------------------------------------
	describe("copy_path actions", function()
		it("writes absolute path to both registers", function()
			local node = make_node({ path = "/tmp/myproject/src/main.lua" })
			stub_manager(make_state("filesystem", node))
			stub_commands("filesystem")

			local items = get_neotree_menu()
			local abs_item = nil
			for _, item in ipairs(items) do
				if item.name:match("absolute path") then
					abs_item = item
					break
				end
			end
			assert.is_not_nil(abs_item, "absolute path item not found")

			-- call it (schedule_wrap returns a function; call the inner function)
			abs_item.cmd()
			vim.wait(50) -- let schedule run

			assert.equals("/tmp/myproject/src/main.lua", vim.fn.getreg('"'))
			assert.equals("/tmp/myproject/src/main.lua", vim.fn.getreg("+"))
		end)

		it("skips message-type nodes without error", function()
			local node = make_node({ type = "message", path = "/tmp/x" })
			stub_manager(make_state("filesystem", node))
			stub_commands("filesystem")

			local items = get_neotree_menu()
			local abs_item
			for _, item in ipairs(items) do
				if item.name:match("absolute path") then abs_item = item; break end
			end
			assert.is_not_nil(abs_item)
			-- must not raise
			assert.has_no_error(function() abs_item.cmd(); vim.wait(50) end)
		end)
	end)

	-- -------------------------------------------------------------------------
	describe("call() actions", function()
		it("invokes the correct neo-tree command", function()
			local called_with = nil
			local node = make_node({})
			local state = make_state("filesystem", node)
			stub_manager(state)

			local cmds = {
				open = function(s) called_with = s end,
			}
			stub_commands("filesystem", cmds)

			local items = get_neotree_menu()
			local open_item
			for _, item in ipairs(items) do
				if item.name:match("Open in window") then open_item = item; break end
			end
			assert.is_not_nil(open_item)

			open_item.cmd()
			vim.wait(50)

			assert.equals(state, called_with)
		end)

		it("falls back to common commands when source command missing", function()
			local called = false
			local node = make_node({})
			local state = make_state("filesystem", node)
			stub_manager(state)
			package.loaded["neo-tree.sources.filesystem.commands"] = {}
			package.loaded["neo-tree.sources.common.commands"] = {
				open = function() called = true end,
			}

			local items = get_neotree_menu()
			local open_item
			for _, item in ipairs(items) do
				if item.name:match("Open in window") then open_item = item; break end
			end
			open_item.cmd()
			vim.wait(50)
			assert.is_true(called)
		end)
	end)

	-- -------------------------------------------------------------------------
	describe("menu item catalogue", function()
		local expected_names = {
			"Open in window",
			"Open in vertical split",
			"Open in horizontal split",
			"Open in new tab",
			"New file",
			"New folder",
			"Delete",
			"File details",
			"Rename",
			"Copy",
			"Cut",
			"Paste",
			"Toggle hidden",
			"Refresh",
			"Copy absolute path",
			"Copy relative path",
			"Open in terminal",
		}

		it("contains all expected menu items", function()
			local node = make_node({})
			stub_manager(make_state("filesystem", node))
			stub_commands("filesystem")

			local items = get_neotree_menu()
			local names = {}
			for _, item in ipairs(items) do
				if item.name ~= "separator" then
					table.insert(names, (item.name:gsub("^%s+", ""):gsub("^[^%a]+", "")))
				end
			end

			for _, expected in ipairs(expected_names) do
				local found = false
				for _, actual in ipairs(names) do
					if actual:lower():find(expected:lower(), 1, true) then
						found = true
						break
					end
				end
				assert.is_true(found, "Missing menu item: " .. expected)
			end
		end)
	end)
end)

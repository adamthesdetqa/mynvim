local function get_neotree_menu()
  local manager = require "neo-tree.sources.manager"
  local cc = require "neo-tree.sources.common.commands"

  -- Capture state now, while neo-tree window still has focus.
  local state = manager.get_state_for_window()
  if not state then return "default" end
  state.config = state.config or {}

  local function close_all_menus()
    local ok, ms = pcall(require, "menu.state")
    if not ok then return end
    for _, bufid in ipairs(ms.bufids or {}) do
      local winid = vim.fn.bufwinid(bufid)
      if winid ~= -1 and vim.api.nvim_win_is_valid(winid) then
        pcall(vim.api.nvim_win_close, winid, true)
      end
    end
    ms.bufs = {}
    ms.bufids = {}
    ms.config = nil
    ms.nested_menu = ""
    vim.cmd "redraw!"
  end

  local function call(what)
    return vim.schedule_wrap(function()
      close_all_menus()
      local cb = require("neo-tree.sources." .. state.name .. ".commands")[what] or cc[what]
      cb(state)
    end)
  end

  local function copy_path(how)
    return vim.schedule_wrap(function()
      close_all_menus()
      local node = state.tree:get_node()
      if node.type == "message" then return end
      vim.fn.setreg('"', vim.fn.fnamemodify(node.path, how))
      vim.fn.setreg("+", vim.fn.fnamemodify(node.path, how))
    end)
  end

  local function open_in_terminal()
    return vim.schedule_wrap(function()
      close_all_menus()
      local node = state.tree:get_node()
      if node.type == "message" then return end
      local path = node.path
      local node_type = vim.uv.fs_stat(path).type
      local dir = node_type == "directory" and path or vim.fn.fnamemodify(path, ":h")
      vim.cmd "enew"
      vim.fn.termopen { vim.o.shell, "-c", "cd " .. dir .. " ; " .. vim.o.shell }
    end)
  end

  return {
    { name = "  Open in window",           cmd = call "open",              rtxt = "o" },
    { name = "  Open in vertical split",   cmd = call "open_vsplit",       rtxt = "v" },
    { name = "  Open in horizontal split", cmd = call "open_split",        rtxt = "s" },
    { name = "󰓪  Open in new tab",         cmd = call "open_tabnew",       rtxt = "O" },
    { name = "separator" },
    { name = "  New file",                 cmd = call "add",               rtxt = "a" },
    { name = "  New folder",               cmd = call "add_directory",     rtxt = "A" },
    { name = "  Delete",       hl = "ExRed",  cmd = call "delete",         rtxt = "d" },
    { name = "   File details",            cmd = call "show_file_details", rtxt = "i" },
    { name = "  Rename",                   cmd = call "rename",            rtxt = "r" },
    { name = "  Copy",                     cmd = call "copy_to_clipboard", rtxt = "y" },
    { name = "  Cut",                      cmd = call "cut_to_clipboard",  rtxt = "x" },
    { name = "  Paste",                    cmd = call "paste_from_clipboard", rtxt = "p" },
    { name = "separator" },
    { name = "Toggle hidden",              cmd = call "toggle_hidden",     rtxt = "H" },
    { name = "Refresh",                    cmd = call "refresh",           rtxt = "R" },
    { name = "separator" },
    { name = "󰴠  Copy absolute path",      cmd = copy_path ":p",          rtxt = "gy" },
    { name = "  Copy relative path",       cmd = copy_path ":~:.",         rtxt = "Y" },
    { name = "  Open in terminal", hl = "ExBlue", cmd = open_in_terminal() },
  }
end

local function get_context_menu(bufnr)
  local ft = vim.bo[bufnr].filetype
  if ft == "neo-tree" then
    return get_neotree_menu()
  end
  
  local menu_items = {}
  
  -- Add spell suggestions if spell check is on and cursor is on a bad word
  if vim.wo.spell then
    local spell_word = vim.fn.spellbadword()[1]
    if spell_word ~= "" then
      local suggestions = vim.fn.spellsuggest(spell_word, 5)
      if #suggestions > 0 then
        local spell_items = {}
        for i, word in ipairs(suggestions) do
          table.insert(spell_items, { 
            name = word, 
            cmd = function() vim.cmd("normal! " .. i .. "z=") end 
          })
        end
        table.insert(menu_items, {
          name = "Spelling Suggestions",
          items = spell_items
        })
        table.insert(menu_items, { name = "separator" })
      end
    end
  end

  -- Add LSP actions if LSP is attached to the buffer
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients > 0 then
    table.insert(menu_items, { name = "Goto Definition", cmd = vim.lsp.buf.definition, rtxt = "gd" })
    table.insert(menu_items, { name = "Goto References", cmd = vim.lsp.buf.references, rtxt = "gr" })
    table.insert(menu_items, { name = "Code Actions", cmd = vim.lsp.buf.code_action, rtxt = "<leader>ca" })
    table.insert(menu_items, { name = "Rename", cmd = vim.lsp.buf.rename, rtxt = "<leader>rn" })
    table.insert(menu_items, { name = "Format", cmd = function() 
      local ok, conform = pcall(require, "conform")
      if ok then conform.format({ lsp_fallback = true }) else vim.lsp.buf.format() end
    end, rtxt = "<leader>mp" })
    table.insert(menu_items, { name = "Lsp Actions (More)", hl = "Exblue", items = "lsp" })
    table.insert(menu_items, { name = "separator" })
  end

  -- Add Gitsigns if there are any git changes in the buffer
  local ok, gitsigns_dict = pcall(vim.api.nvim_buf_get_var, bufnr, "gitsigns_status_dict")
  if ok and gitsigns_dict then
    table.insert(menu_items, { name = "Git Actions", hl = "Exblue", items = "gitsigns" })
    table.insert(menu_items, { name = "separator" })
  end
  
  -- Add default base items
  local ok_default, default_menu = pcall(require, "menus.default")
  if ok_default then
    for _, item in ipairs(default_menu) do
      if item.name ~= "Code Actions" and item.name ~= "Format Buffer" and item.name ~= "  Lsp Actions" then
        if item.name == "separator" then
          if #menu_items > 0 and menu_items[#menu_items].name ~= "separator" then
            table.insert(menu_items, item)
          end
        else
          table.insert(menu_items, item)
        end
      end
    end
  end
  
  -- Remove trailing separator if it exists
  if #menu_items > 0 and menu_items[#menu_items].name == "separator" then
    table.remove(menu_items, #menu_items)
  end

  -- Fallback if empty
  if #menu_items == 0 then
    return "default"
  end

  return menu_items
end

return {
  { "nvzone/volt", lazy = true },
  {
    "nvzone/menu",
    lazy = true,
    keys = {
      { "<C-t>", function()
          local buf = vim.api.nvim_get_current_buf()
          require("menu").open(get_context_menu(buf))
        end, mode = "n", desc = "Open Menu" },
      { "<RightMouse>", function()
          vim.cmd.exec '"normal! \\<RightMouse>"'
          local winid = vim.fn.getmousepos().winid
          local buf = vim.api.nvim_win_get_buf(winid)
          require("menu").open(get_context_menu(buf), { mouse = true })
        end, mode = "n", desc = "Open Menu" }
    },
    config = function()
      -- Fix navigation for NvMenu buffer based on your custom hjkl layout

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "NvMenu",
        callback = function(args)
          local buf = args.buf
          vim.schedule(function()
            -- Remap 'j' to left, ';' to right to navigate nested menus
            vim.keymap.set("n", "j", function() require("menu.utils").switch_win(-1) end, { buffer = buf, desc = "Prev Menu" })
            vim.keymap.set("n", ";", function() require("menu.utils").switch_win(1) end, { buffer = buf, desc = "Next Menu" })

            -- Remap 'l' to up, 'k' to down (matching your init.lua settings)
            vim.keymap.set("n", "l", "k", { buffer = buf, remap = false, desc = "Menu Up" })
            vim.keymap.set("n", "k", "j", { buffer = buf, remap = false, desc = "Menu Down" })

                        -- Map Spacebar to select the current option
            vim.keymap.set("n", "<Space>", "<CR>", { buffer = buf, remap = true, desc = "Select Menu Item" })
            
            -- Ensure 'q' cleanly closes the menu
            local close_menu = function()
              local ok, utils = pcall(require, "volt.utils")
              local s_ok, state = pcall(require, "menu.state")
              if ok and s_ok then
                utils.close({ 
                  bufs = vim.tbl_keys(state.bufs or {}),
                  after_close = function()
                    state.bufs = {}
                    state.config = nil
                    state.nested_menu = ""

                    if state.old_data and state.old_data.win and vim.api.nvim_win_is_valid(state.old_data.win) then
                      vim.api.nvim_set_current_win(state.old_data.win)
                      vim.schedule(function()
                        if state.old_data.cursor then
                          local cursor_line = math.max(1, state.old_data.cursor[1])
                          local cursor_col = math.max(0, state.old_data.cursor[2])
                          pcall(vim.api.nvim_win_set_cursor, state.old_data.win, { cursor_line, cursor_col })
                        end
                      end)
                    end

                    state.bufids = {}
                    vim.schedule(function() vim.cmd("redraw!") end)
                  end
                })
              end
            end
            
            vim.keymap.set("n", "q", close_menu, { buffer = buf, remap = false, desc = "Close Menu" })
            vim.keymap.set("n", "<Esc>", close_menu, { buffer = buf, remap = false, desc = "Close Menu" })
          end)
        end,
      })
    end,
  }
}

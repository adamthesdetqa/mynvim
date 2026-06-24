local function get_context_menu(bufnr)
  local ft = vim.bo[bufnr].filetype
  if ft == "neo-tree" then
    return "neo-tree"
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
            
            -- Cleanly close the menu and clear artifacts
            local close_menu = function()
              local state = require("menu.state")

              -- Close all menu windows
              for _, win_id in ipairs(state.bufs or {}) do
                if vim.api.nvim_win_is_valid(win_id) then
                  vim.api.nvim_win_close(win_id, true)
                end
              end

              -- Delete all menu buffers
              for _, buf_id in ipairs(state.bufids or {}) do
                if vim.api.nvim_buf_is_valid(buf_id) then
                  vim.api.nvim_buf_delete(buf_id, { force = true })
                end
              end

              -- Clear state
              state.bufs = {}
              state.bufids = {}

              -- Full redraw to clear any visual artifacts
              vim.cmd("redraw!")
            end

            vim.keymap.set("n", "q", close_menu, { buffer = buf, remap = false, desc = "Close Menu" })
            vim.keymap.set("n", "<Esc>", close_menu, { buffer = buf, remap = false, desc = "Close Menu" })
          end)
        end,
      })
    end,
  }
}

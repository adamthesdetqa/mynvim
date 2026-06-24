return {
  { "nvzone/volt", lazy = true },
  {
    "nvzone/menu",
    lazy = true,
    keys = {
      { "<C-t>", function()
          local options = vim.bo.filetype == "neo-tree" and "neo-tree" or "default"
          require("menu").open(options)
        end, mode = "n", desc = "Open Menu" },
      { "<RightMouse>", function()
          vim.cmd.exec '"normal! \\<RightMouse>"'
          local winid = vim.fn.getmousepos().winid
          local buf = vim.api.nvim_win_get_buf(winid)
          local options = vim.bo[buf].filetype == "neo-tree" and "neo-tree" or "default"
          require("menu").open(options, { mouse = true })
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
            vim.keymap.set("n", "q", function() 
              require("volt.utils").close({ bufs = vim.tbl_keys(require("menu.state").bufs) })
            end, { buffer = buf, remap = false, desc = "Close Menu" })
          end)
        end,
      })
    end,
  }
}

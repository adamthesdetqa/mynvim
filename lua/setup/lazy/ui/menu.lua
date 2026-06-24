return {
  { "nvzone/volt", lazy = true },
  {
    "nvzone/menu",
    lazy = true,
    keys = {
      { "<C-t>", function()
          local options = vim.bo.filetype == "neo-tree" and "neo-tree" or "default"
          require("menu").open(options, { border = true })
        end, mode = "n", desc = "Open Menu" },
      { "<RightMouse>", function()
          vim.cmd.exec '"normal! \\<RightMouse>"'
          local winid = vim.fn.getmousepos().winid
          local buf = vim.api.nvim_win_get_buf(winid)
          local options = vim.bo[buf].filetype == "neo-tree" and "neo-tree" or "default"
          require("menu").open(options, { mouse = true, border = true })
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
          end)
        end,
      })

      -- Force a redraw when the menu closes to clear any black UI artifacts
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = "*",
        callback = function(args)
          if args.buf and vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].filetype == "NvMenu" then
            vim.schedule(function() vim.cmd("redraw!") end)
          end
        end,
      })
    end,
  }
}

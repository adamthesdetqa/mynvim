vim.opt.termguicolors = true
vim.cmd("Neotree show")
vim.schedule(function()
  -- open menu
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-t>", true, false, true), "n", true)
  
  -- wait and press q
  vim.defer_fn(function()
    vim.api.nvim_feedkeys("q", "n", true)
    
    -- wait and dump window info
    vim.defer_fn(function()
      print("Windows:")
      for _, w in ipairs(vim.api.nvim_list_wins()) do
        local b = vim.api.nvim_win_get_buf(w)
        print(" win="..w.." buf="..b.." ft="..vim.bo[b].filetype)
      end
      vim.cmd("qa!")
    end, 50)
  end, 50)
end)
